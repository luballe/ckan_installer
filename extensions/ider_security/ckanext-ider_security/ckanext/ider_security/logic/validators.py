# encoding: utf-8

import collections
import datetime
from itertools import count
import re
import mimetypes

import ckan.lib.navl.dictization_functions as df
import ckan.logic as logic
import ckan.lib.helpers as h
from ckan.model import (MAX_TAG_LENGTH, MIN_TAG_LENGTH,
                        PACKAGE_NAME_MIN_LENGTH, PACKAGE_NAME_MAX_LENGTH,
                        PACKAGE_VERSION_MAX_LENGTH,
                        VOCABULARY_NAME_MAX_LENGTH,
                        VOCABULARY_NAME_MIN_LENGTH)
import ckan.authz as authz
from ckan.model.core import State

from ckan.common import _

Invalid = df.Invalid
StopOnError = df.StopOnError
Missing = df.Missing
missing = df.missing

def user_password_validator(key, data, errors, context):
    value = data[key]
    print(" ## -->> user_password_validator from IDER_SECURITY")
    if isinstance(value, Missing):
        pass
    elif not isinstance(value, basestring):
        errors[('password',)].append(_('Passwords must be strings'))
    elif value == '':
        pass
    elif len(value) < 5:
        errors[('password',)].append(_('Your password must be 5 characters or longer'))

def user_password_not_empty(key, data, errors, context):
    '''Only check if password is present if the user is created via action API.
       If not, user_both_passwords_entered will handle the validation'''

    # sysadmin may provide password_hash directly for importing users
    if (data.get(('password_hash',), missing) is not missing and
            authz.is_sysadmin(context.get('user'))):
        return

    if not ('password1',) in data and not ('password2',) in data:
        password = data.get(('password',),None)
        if not password:
            errors[key].append(_('Missing value'))

