export type OmitByValueType<T, ValueTypeToExclude> = Pick<
  T,
  {
    [K in keyof T]: T[K] extends ValueTypeToExclude ? never : K;
  }[keyof T]
>;
