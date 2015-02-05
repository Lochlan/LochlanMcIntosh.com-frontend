define([
    'views/contact',
], function (ContactView) {
    'use strict';

    describe('contact view', function () {
        var view;

        beforeEach(function() {
            view = new ContactView();
        });

        describe('when constructing', function () {
            it ('should exist', function () {
                expect(view).toBeDefined();
            });

            it('should have a template', function() {
                expect(view.template).toBeDefined();
            });
        });
    });

});
