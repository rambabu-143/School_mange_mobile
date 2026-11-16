import * as React from 'react';
import {
  ActivityIndicator,
  Dimensions,
  FlatList,
  Image,
  Modal,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import { SafeAreaProvider, SafeAreaView } from 'react-native-safe-area-context';
import dayjs from 'dayjs';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { GalleryEvent, useGalleryQuery } from '@/queries/useGalleryQuery';

const SCREEN_WIDTH = Dimensions.get('window').width;

export default function GalleryScreen() {
  const galleryQuery = useGalleryQuery();
  const theme = useTheme();
  const [selectedEvent, setSelectedEvent] = React.useState<GalleryEvent | null>(null);
  const [fullScreenIndex, setFullScreenIndex] = React.useState<number | null>(null);

  const path = galleryQuery.data?.path ?? '';

  if (galleryQuery.isLoading) {
    return (
      <ThemedView style={styles.centered}>
        <ActivityIndicator size="large" color="#2658A5" />
      </ThemedView>
    );
  }

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <FlatList
        data={galleryQuery.data?.data ?? []}
        keyExtractor={(item, index) => item._id ?? index.toString()}
        contentContainerStyle={styles.listContent}
        renderItem={({ item }) => (
          <TouchableOpacity
            style={[styles.card, { backgroundColor: theme.backgroundElement }]}
            disabled={item.images.length === 0}
            onPress={() => setSelectedEvent(item)}
          >
            <Image
              source={{ uri: `${path}${item.thumbnail ?? item.images[0]?.file_name}` }}
              style={[styles.thumbnail, { backgroundColor: theme.backgroundSelected }]}
            />
            <View style={styles.cardInfo}>
              <ThemedText style={styles.title}>{item.name}</ThemedText>
              <ThemedText themeColor="textSecondary" style={styles.date}>{dayjs(item.event_date).format('DD-MM-YYYY')}</ThemedText>
              <ThemedText themeColor="textSecondary" style={styles.date}>{item.images.length} photo(s)</ThemedText>
            </View>
          </TouchableOpacity>
        )}
        ListEmptyComponent={
          <ThemedView style={styles.centered}>
            <ThemedText themeColor="textSecondary" style={styles.date}>
              {galleryQuery.isError ? galleryQuery.error.message : 'No gallery events found!'}
            </ThemedText>
          </ThemedView>
        }
        refreshing={galleryQuery.isRefetching}
        onRefresh={() => galleryQuery.refetch()}
      />

      {/* Grid of an event's photos */}
      <Modal visible={!!selectedEvent} animationType="slide" onRequestClose={() => setSelectedEvent(null)}>
        <SafeAreaProvider>
        <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }}>
          <View style={[styles.modalHeader, { borderBottomColor: theme.backgroundSelected }]}>
            <ThemedText style={styles.title}>{selectedEvent?.name}</ThemedText>
            <TouchableOpacity onPress={() => setSelectedEvent(null)}>
              <Text style={styles.closeText}>Close</Text>
            </TouchableOpacity>
          </View>

          <FlatList
            data={selectedEvent?.images ?? []}
            keyExtractor={(image, index) => image._id ?? index.toString()}
            numColumns={3}
            contentContainerStyle={styles.gridContent}
            renderItem={({ item, index }) => (
              <TouchableOpacity onPress={() => setFullScreenIndex(index)}>
                <Image source={{ uri: `${path}${item.file_name}` }} style={[styles.gridImage, { backgroundColor: theme.backgroundSelected }]} />
              </TouchableOpacity>
            )}
          />
        </SafeAreaView>
        </SafeAreaProvider>
      </Modal>

      {/* Full-screen swipeable viewer */}
      <Modal visible={fullScreenIndex !== null} animationType="fade" onRequestClose={() => setFullScreenIndex(null)}>
        <SafeAreaProvider>
        <SafeAreaView style={styles.pagerBackdrop}>
          <TouchableOpacity style={styles.pagerCloseButton} onPress={() => setFullScreenIndex(null)}>
            <Text style={styles.pagerCloseText}>Close</Text>
          </TouchableOpacity>

          <FlatList
            data={selectedEvent?.images ?? []}
            keyExtractor={(image, index) => image._id ?? index.toString()}
            horizontal
            pagingEnabled
            initialScrollIndex={fullScreenIndex ?? 0}
            getItemLayout={(_data, index) => ({ length: SCREEN_WIDTH, offset: SCREEN_WIDTH * index, index })}
            renderItem={({ item }) => (
              <Image
                source={{ uri: `${path}${item.file_name}` }}
                style={{ width: SCREEN_WIDTH, height: '100%' }}
                resizeMode="contain"
              />
            )}
          />
        </SafeAreaView>
        </SafeAreaProvider>
      </Modal>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, minHeight: 300, alignItems: 'center', justifyContent: 'center' },
  listContent: { gap: 12, padding: 12 },
  card: { flexDirection: 'row', gap: 12, padding: 12, borderRadius: 8 },
  thumbnail: { width: 64, height: 64, borderRadius: 8 },
  cardInfo: { flex: 1, gap: 2, justifyContent: 'center' },
  title: { fontSize: 16, fontWeight: '600' },
  date: { fontSize: 12 },
  modalHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: 16,
    borderBottomWidth: StyleSheet.hairlineWidth,
  },
  closeText: { color: '#007AFF', fontSize: 16, fontWeight: '600' },
  gridContent: { padding: 4, gap: 4 },
  gridImage: { width: (SCREEN_WIDTH - 32) / 3, height: (SCREEN_WIDTH - 32) / 3, margin: 4 },
  pagerBackdrop: { flex: 1, backgroundColor: '#000000' },
  pagerCloseButton: { position: 'absolute', top: 50, right: 16, zIndex: 10, padding: 8 },
  pagerCloseText: { color: '#ffffff', fontSize: 16, fontWeight: '600' },
});
