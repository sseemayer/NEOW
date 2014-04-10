memcache = require '../src/caching/memory'
diskcache = require '../src/caching/disk'


cacheTest = (cacheName, cacheClass) =>

  describe cacheName, =>
    cache = null

    beforeEach =>
      cache = new cacheClass

    it "should fail on non-existing keys", (done) =>
      expect(cache.get("nonexistant")).to.be.rejectedWith(Error).notify(done)

    it "should allow setting", (done) =>
      expect(cache.set("anelement", new Date + 10000, {a: 'value'})).to.become(true).notify(done)

    it "should allow deleting", (done) =>
      cache.set("anelement", new Date + 10000, {a: 'value'})
        .then ->
          expect(cache.del("anelement")).to.become(true).notify(done)

    it "should retrieve existing keys", (done) =>
      cache.set("anelement", new Date + 10000, {a: 'value'})
        .then ->
          expect(cache.get("anelement")).to.become({a: 'value'}).notify(done)

    it "should not retrieve expired keys", (done) =>
      cache.set("anelement", new Date - 100, {a: 'value'})
        .then ->
          expect(cache.get("anelement")).to.be.rejectedWith(Error).notify(done)

    it "should not retrieve keys after deletion", (done) =>

      cache.set("anelement", new Date + 10000, {a: 'value'})
        .then ->
          cache.del("anelement")
            .then ->
              expect(cache.get("anelement")).to.be.rejectedWith(false).notify(done)

cacheTest "MemoryCache", memcache.MemoryCache
cacheTest "DiskCache", diskcache.DiskCache
