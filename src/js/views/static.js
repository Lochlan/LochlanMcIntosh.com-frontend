define([
    'backbone',
    'templates/about',
    'templates/home',
    'templates/portfolio',
    'templates/resume',
], function (Backbone, aboutTemplate, homeTemplate, portfolioTemplate, resumeTemplate) {
    'use strict';

    var StaticView = Backbone.View.extend({

        template: undefined,
        templates: {
            about: aboutTemplate,
            home: homeTemplate,
            portfolio: portfolioTemplate,
            resume: resumeTemplate,
        },

        render: function (template) {
            if (template) {
                this.template = template;
            }
            this.$el.html(this.template());

            return this;
        },

        renderTemplate: function(templateKey) {
            this.template = this.templates[templateKey];
            return this.render();
        }

    });

    return StaticView;
});
