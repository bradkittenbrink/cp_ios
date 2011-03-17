/*
 * @copyright Copyright (c) Coffee And Power Inc. 2011 All Rights Reserved. 
 * http://www.coffeeandpower.com
 * @author H <h@singinghorsestudio.com>
 * 
 * @brief Model for top header bar.  We put all our complex logic here to keep the view clean
 * 
 */


var headerBarModel = {};

(function() {
    headerBarModel.loginButton = function(e) {
        switch(e.source.title) {
            case L('login'):
                Ti.App.fireEvent('app:login.toggle');
                break;

            case L('logout'):
                candp.model.xhr(
                    candp.config.logoutUrl,
                    'POST',
                    {}, 
                    function(e) {
                        // we've logged out, so let the user know
                        candp.view.alert(L('logged_out'), L('logged_out_message'));
                        Ti.App.fireEvent('app:headerBar.changeState', {
                            newState: 'loggedOut'
                        });
                    }
                );
                break;
        }         
    };

    headerBarModel.changeState = function(e) {
        switch(e.newState) {
            case 'loggedIn':
                // let's check that we're really logged in
                candp.model.xhr(
                    candp.config.actionServerUrl,
                    'POST',
                    {
                        action: 'isLoggedIn'
                    },
                    function(e) {
                        var params = JSON.parse(e.response).params;
                        var logged = params.logged;
                        
                        Ti.API.info('logged = ' + logged);
                        
                        if (logged === 'true') {
                            // we're logged in, so 
                            // *TODO: Get GPS lat&long and register at the server

                            // candp.location = applicationModel.getGPS();


		                    // ... collect the missions now that we've logged in
			                Ti.App.fireEvent('app:missionList.getMissions');
                    
                            // ... and we can get the nickname and balance etc
                            Ti.App.fireEvent('headerBar:loginButton.changeText', {
                                 newText: L('logout')
                            });
                            Ti.App.fireEvent('headerBar:headerBarNickname.changeText', {
                                 newText: params.userData.nickname + ' - '
                            });
                            Ti.App.fireEvent('headerBar:headerBarBalance.changeText', {
                                 newText: '$' + params.userData.balance
                            });
                        }
                    }
                );
                break;

            case 'loggedOut':
	            Ti.App.fireEvent('headerBar:loginButton.changeText', {
	                 newText:  L('login')
	            });
	            Ti.App.fireEvent('headerBar:headerBarNickname.changeText', {
	                 newText: L('coffee_and_power')
	            });
	            Ti.App.fireEvent('headerBar:headerBarBalance.changeText', {
	                 newText: ' '
	            });
                break;
        }    
    };

    headerBarModel.getUserBalance = function(callback) {
        candp.model.xhr(
            candp.config.actionServerUrl,
            'POST',
            {
                action: 'getUserBalance'
            },
            function(e) {
                var response = JSON.parse(e.response);
                if (response.params.balance) {
                    callback(response.params.balance);                    
                }
            }
        );
    };


})();
