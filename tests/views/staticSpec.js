define([
    'underscore',
    'views/static',
], function (_, StaticView) {
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

            it('should not have a template set', function() {
                expect(view.template).not.toBeDefined();
            });

            it('should have a renderTemplate method', function () {
                expect(view.renderTemplate).toBeDefined();
            });

            it('should throw an exception if render is called without an argument', function() {
                expect(view.render).toThrow();
            });
        });

        describe('when rendered with a passed-in template', function () {
            var template = _.template('<h1>Hello, world!</h1>');

            beforeEach(function () {
                view.render(template);
            });

            it('should have a template set to the passed-in value', function() {
                expect(view.template).toEqual(template);
            });

            it('should have content in el', function () {
                expect(view.el.innerHTML).not.toEqual('');
            });
        });

        describe('when rendered with renderTemplate', function () {
            beforeEach(function () {
                spyOn(view, 'render').and.callThrough();
                view.renderTemplate('about');
            });

            it('should have a template set', function() {
                expect(view.template).toBeDefined();
            });

            it('should call render', function () {
                expect(view.render).toHaveBeenCalled();
            });

            it('should have content in el', function () {
                expect(view.el.innerHTML).not.toEqual('');
            });
        });
    });

});
