define([
    'views/static',
], function (StaticView) {
    'use strict';

    describe('static view', function () {
        var view;

        beforeEach(function() {
            view = new StaticView();
        });

        describe('when constructing', function () {
            it ('should exist', function () {
                expect(view).toBeDefined();
            });

            it('should not have a template', function() {
                expect(view.template).not.toBeDefined();
            });
        });
    });

});
