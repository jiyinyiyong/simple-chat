
React = require 'react'
socket = require '../resource/socket'

$ = React.DOM

$$ = require '../utils/helper'

module.exports = React.createClass
  displayName: 'login-view'

  getInitialState: ->
    hasAccount: yes
    error: null

  showLogin: ->
    @setState hasAccount: yes, error: null

  showSignup: ->
    @setState hasAccount: no, error: null

  login: ->
    @setState error: null

    name = @refs.name.getDOMNode().value
    if name.length is 0
      @setState error: 'name is empty'
      return

    password = @refs.password.getDOMNode().value
    if password.length < 4
      @setState error: 'Password is too short'
      return

    socket.send 'login', {name, password}, (resp) =>
      @setState error: resp.error

  signup: ->
    @setState error: null

    name = @refs.name.getDOMNode().value
    if name.length is 0
      @setState error: 'Email is empty'
      return

    password = @refs.password.getDOMNode().value
    if password.length < 4
      @setState error: 'Password is too short'
      return

    password2 = @refs.password2.getDOMNode().value
    if password isnt password2
      @setState error: 'Passwords do not match'
      console.log @state
      return

    socket.send 'signup', {name, password, password2}, (resp) =>
      @setState error: resp.error

  render: ->
    $.div className: 'login-view',
      if @state.hasAccount
        $.div className: 'panel be-signup',
          $.div className: 'header',
            'Login'
            $.span className: 'entry-text', onClick: @showSignup,
              'Need account?'
          $.div className: 'content',
            $.input className: 'be-large', type: 'text', placeholder: 'Name', ref: 'name'
            $.input className: 'be-large', type: 'password', placeholder: 'Password', ref: 'password'
            if @state.error?
              $.div className: 'label be-error',
                @state.error
            $.div className: 'button be-large', onClick: @login,
              'Log in'
      else
        $.div className: 'panel be-login',
          $.div className: 'header',
            'Signup'
            $.span className: 'entry-text', onClick: @showLogin,
              'Already have account?'
          $.div className: 'content',
            $.input className: 'be-large', type: 'text', placeholder: 'Name', ref: 'name'
            $.input className: 'be-large', type: 'password', placeholder: 'Password', ref: 'password'
            $.input className: 'be-large', type: 'password', placeholder: 'Confirm password', ref: 'password2'
            if @state.error?
              $.div className: 'label be-error',
                @state.error
            $.div
              className: 'button be-large'
              onClick: @signup
              'Sign up'