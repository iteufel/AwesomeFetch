export * from './definitions';
export * from './web';

if((window as any).Capacitor.Plugins) {
  (window as any)['_fetch'] = window['fetch'];
  window['fetch'] = ((url: string, opts: any = {}) => {
    if (opts.headers) {
      Object.assign(opts.headers, { 'X-Url': url });
    } else {
      opts.headers = { 'X-Url': url };
    }
    return (window as any)['_fetch']('http://127.0.0.1:8078/', opts);
  }) as any;
}
