declare global {
  interface PluginRegistry {
    CapacitorAwesomeFetch?: CapacitorAwesomeFetchPlugin;
  }
}

export interface CapacitorAwesomeFetchPlugin {
  echo(options: { value: string }): Promise<{value: string}>;
}
