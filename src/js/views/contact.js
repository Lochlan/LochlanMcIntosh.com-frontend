define([
    'backbone',
    'models/message',
    'templates/contact',
], function (Backbone, Model, template) {
    'use strict';

    var ContactView = Backbone.View.extend({

        model: new Model(),
        template: template,

        render: function () {
            this.$el.html(this.template(this.model.attributes));

            return this;
        },

        submit: function (event) {
            event.preventDefault();

            var input = this.$('input[name=email]')[0].value;
            console.log(input);


            var fields = this.$('form [name]');
            var userInput = _.object(_.map(fields, function (field) {
                return [field.name, field.value];
            }));

            console.log(userInput);
            // TODO add url to enable saving
            // this.model.set(userInput).save();
        },

        events: {
            'submit form': 'submit',
        },

    });

    return ContactView;
});
