import { WebPlugin } from '@capacitor/core';
import { CapacitorAwesomeFetchPlugin } from './definitions';

export class CapacitorAwesomeFetchWeb extends WebPlugin implements CapacitorAwesomeFetchPlugin {
  constructor() {
    super({
      name: 'CapacitorAwesomeFetch',
      platforms: ['web']
    });
  }

  async echo(options: { value: string }): Promise<{value: string}> {
    console.log('ECHO', options);
    return Promise.resolve({ value: options.value });
  }
}

const CapacitorAwesomeFetch = new CapacitorAwesomeFetchWeb();

export { CapacitorAwesomeFetch };
