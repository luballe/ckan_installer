import ckan.plugins as plugins
import ckan.plugins.toolkit as toolkit
import ckan.logic.validators

def user_password_validator(key, data, errors, context):
    print('Using user_password_validator form Plugingggggggg ')
    value = data[key]

    if isinstance(value, Missing):
        pass
    elif not isinstance(value, basestring):
        errors[('password',)].append(_('Passwords must be strings'))
    elif value == '':
        pass
    elif len(value) < 8:
        errors[('password',)].append(_('Your password must be 8 characters or longer'))


class Ider_SecurityPlugin(plugins.SingletonPlugin):
    plugins.implements(plugins.IConfigurer)

    # IConfigurer
    def update_config(self, config_):
        toolkit.add_template_directory(config_, 'templates')
        toolkit.add_public_directory(config_, 'public')
        toolkit.add_resource('fanstatic', 'ider_security')
	ckan.logic.validators.user_password_validatoy = user_password_validator
	print(' -Ider_SecurityPlugin - ')

    def user_password_validator(key, data, errors, context):
        return {'user_password_validator': user_password_validator}
