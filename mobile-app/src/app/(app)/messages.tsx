import * as React from 'react';
import { ActivityIndicator, FlatList, Modal, ScrollView, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import dayjs from 'dayjs';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { useTheme } from '@/hooks/use-theme';
import { MessageItem, useMarkMessageReadMutation, useMessagesQuery } from '@/queries/useMessagesQuery';

export default function MessagesScreen() {
  const messagesQuery = useMessagesQuery();
  const markReadMutation = useMarkMessageReadMutation();
  const [selected, setSelected] = React.useState<MessageItem | null>(null);
  const theme = useTheme();

  const openMessage = (item: MessageItem) => {
    setSelected(item);
    if (!item.mobiles?.[0]?.read_flag && item._id) {
      markReadMutation.mutate(item._id);
    }
  };

  if (messagesQuery.isLoading) {
    return (
      <ThemedView style={styles.centered}>
        <ActivityIndicator size="large" color="#2658A5" />
      </ThemedView>
    );
  }

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: theme.background }} edges={['left', 'right', 'bottom']}>
      <FlatList
        data={messagesQuery.data ?? []}
        keyExtractor={(item, index) => item._id ?? index.toString()}
        contentContainerStyle={styles.listContent}
        renderItem={({ item }) => {
          const isRead = !!item.mobiles?.[0]?.read_flag;
          return (
            <TouchableOpacity style={[styles.card, { backgroundColor: theme.backgroundElement }]} onPress={() => openMessage(item)}>
              <View style={styles.row}>
                <ThemedText style={styles.text} numberOfLines={2}>
                  {item.sms_text}
                </ThemedText>
                <View style={[styles.dot, isRead ? styles.dotRead : styles.dotUnread]} />
              </View>
              <ThemedText themeColor="textSecondary" style={styles.date}>{dayjs(item.created_at).format('DD-MM-YYYY | hh:mm a')}</ThemedText>
            </TouchableOpacity>
          );
        }}
        ListEmptyComponent={
          <ThemedView style={styles.centered}>
            <ThemedText themeColor="textSecondary" style={styles.text}>
              {messagesQuery.isError ? messagesQuery.error.message : 'No messages found!'}
            </ThemedText>
          </ThemedView>
        }
        refreshing={messagesQuery.isRefetching}
        onRefresh={() => messagesQuery.refetch()}
      />

      <Modal visible={!!selected} animationType="slide" transparent onRequestClose={() => setSelected(null)}>
        <View style={styles.modalBackdrop}>
          <View style={[styles.modalContent, { backgroundColor: theme.backgroundElement }]}>
            <TouchableOpacity style={styles.closeButton} onPress={() => setSelected(null)} hitSlop={12}>
              <Text style={styles.closeButtonText}>✕ Close</Text>
            </TouchableOpacity>
            {/* no flex:1 here — in a content-sized column it collapses the text to zero height */}
            <ScrollView style={{ maxHeight: 360 }}>
              <ThemedText style={styles.modalText}>{selected?.sms_text}</ThemedText>
            </ScrollView>
            <ThemedText themeColor="textSecondary" style={styles.date}>{dayjs(selected?.created_at).format('DD-MM-YYYY | hh:mm a')}</ThemedText>
          </View>
        </View>
      </Modal>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  centered: { flex: 1, minHeight: 300, alignItems: 'center', justifyContent: 'center' },
  listContent: { gap: 12, padding: 12 },
  card: { gap: 6, padding: 12, borderRadius: 8 },
  row: { flexDirection: 'row', alignItems: 'flex-start', gap: 8 },
  text: { flex: 1, fontSize: 15 },
  modalText: { fontSize: 15 },
  date: { fontSize: 12 },
  dot: { width: 8, height: 8, borderRadius: 4, marginTop: 4 },
  dotRead: { backgroundColor: '#c4c4c4' },
  dotUnread: { backgroundColor: '#3c87f7' },
  modalBackdrop: { flex: 1, backgroundColor: 'rgba(0,0,0,0.4)', justifyContent: 'flex-end' },
  modalContent: { padding: 20, gap: 12, borderTopLeftRadius: 16, borderTopRightRadius: 16 },
  closeButton: { alignSelf: 'flex-end', paddingVertical: 8, paddingHorizontal: 16 },
  closeButtonText: { color: '#007AFF', fontSize: 16, fontWeight: '600' },
});
