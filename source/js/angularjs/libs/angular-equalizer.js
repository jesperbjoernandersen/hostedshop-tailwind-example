angular
.module('ngEqualizer', [])
.factory('EqualizerState', ['$window','$rootScope', function($window, $rootScope) {
  var equalize, items;

  items = {};

  equalize = _.debounce(function() {
    var i, item, maxHeight, name, _i, _j, _len, _len1;

    for (name in items) {
      item = items[name];
      maxHeight = 0;

      for (_i = 0, _len = item.length; _i < _len; _i++) {
        i = item[_i];
        i.css('height', 'auto');
        var h = i.outerHeight();
        if (maxHeight < h) {
          maxHeight = h;
        }
      }

      if (maxHeight > 0) {
        for (_j = 0, _len1 = item.length; _j < _len1; _j++) {
          i = item[_j];
          i.css('height', maxHeight);
        }
      }
    }
  }, 10);

  $window = $($window);

  $window.on('resize', equalize);

  $rootScope.$on('equalizer.rerun', function() {
    equalize();
  });

  return {
    get: function(group) {
      return items[group];
    },
    add: function(group, item) {
      if (typeof items[group] === 'undefined'){
        items[group] = [];
      }
      items[group].push(item);
      equalize();

      return this;
    }
  };
}])
.directive('equalizer', ['EqualizerState', function(EqualizerState) {
    return {
      restrict: 'A',
      link: function(scope, el, attr) {
        if (!attr.equalizer) {
          return;
        }
        EqualizerState.add(attr.equalizer, el);
      }
    };
  }
]);
