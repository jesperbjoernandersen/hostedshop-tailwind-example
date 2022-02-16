; (function ($, platform) {
    
    var scrollHistory = {
        
        history       : null,
        sessionKey    : 'scrollHistory',
        hasSearch     : window.location.href.search(/\?search\=/) !== -1,
        userScrolled  : false,
        tooLate       : this.userScrolled || false,
        maxTimeToLoad : 5000,
        
        init : function () {
            
            var self = this, $window = $(window);
            
            self.isProductlist = platform.page.isProduct && (platform.page.paths.length === 2 || self.hasSearch);

            if (!self.hasSessionStorage() || !self.isProductlist) {
                return;
            }

            $window.bind('unload', function () {
                self.saveScrollPosition();
            });

            self.history =  this.loadScrollHistory() || null;
            
            if (!self.history) {
                return;
            }
            
            $window.bind('scroll', function () {
                self.userScrolled = true;
            });
            
            self.scrollBackToPosition();
        },
        
        scrollBackToPosition : function () {
            var self = this,
                offset = parseInt(self.history.offset),
                href = self.history.location;
            
            if (offset < 10 || $('.w-notification').length || href !== window.location.href) { 
                return; 
            }
            setTimeout(function () {
                self.tooLate = true;
            }, self.maxTimeToLoad);
            
            // Productlist Ready
            $(platform).bind('loaded.productlist', function () {
                if (self.tooLate){
                    return;
                }
                setTimeout(function () {
                    window.scrollTo(0, offset);
                    sessionStorage.removeItem(self.sessionKey);
                }, 250);
            });
        },
        
        loadScrollHistory : function () {
            var scrollHistory = sessionStorage.getItem(this.sessionKey);
            return scrollHistory ? JSON.parse(scrollHistory) : null;
        },
        
        saveScrollPosition : function () {
            sessionStorage.setItem(
                this.sessionKey, 
                JSON.stringify({
                    offset: window.scrollY || window.pageYOffset,
                    location: window.location.href
                })
            );
        },
        
        hasSessionStorage : function () {
            var test = 'test string';
            try {
                sessionStorage.setItem(test, test);
                sessionStorage.removeItem(test);
                return true;
            } catch (e) {
                return false;
            }
        }
    }

    window.addEventListener('DOMContentLoaded', 
        scrollHistory.init.bind(scrollHistory)
    );

})(jQuery, window.platform);