define([
    'backbone',
    'views/contact',
    'views/static',
], function (Backbone, ContactView, StaticView) {
    'use strict';

    var Router = Backbone.Router.extend({

        routes: {
            '': 'home',
            'about': 'static',
            'contact': 'contact',
            'home': 'static',
            'portfolio': 'static',
            'resume': 'static',
        },

        views: {
            contact: new ContactView({ el: '.js-Backbone'}),
            staticpage: new StaticView({ el: '.js-Backbone'}),
        },

        initialize: function () {
            Backbone.history.start({
                root: location.pathname,
            });
        },

        contact: function () {
            this.views.contact.render();
        },

        home: function () {
            this.views.staticpage.renderTemplate('home');
        },

        static: function () {
            this.views.staticpage.renderTemplate(Backbone.history.fragment);
        },

    });

    return Router;
});
