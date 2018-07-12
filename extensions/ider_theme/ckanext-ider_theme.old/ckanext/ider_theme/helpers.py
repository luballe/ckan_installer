
import ckan.plugins.toolkit as toolkit

from pprint import pprint
from logging import getLogger

log = getLogger(__name__)

def all_groups():
    '''Return a sorted list of the groups with the most datasets.'''
    # Get a list of all the site's groups from CKAN, sorted by number of
    # datasets.pprint()
    context = {'ignore_auth': True,
               'for_view': True
              }
    data_dict={'order_by': 'name', 'all_fields': True }

    groups = toolkit.get_action('group_list')( context, data_dict )
    
    filtered = [ group for group in groups if group ["package_count"] > 0 ]
    log.error(pprint(filtered))
             

#    return filtered
    return groups

def all_packages():
    '''Return a sorted list of the packages with the most recent modifications.'''
    # Get a list of all the packages from CKAN, sorted by date.
    context = {'ignore_auth': True,
               'for_view': True
              }
    data_dict={ 'all_fields': True }

    packages = toolkit.get_action('current_package_list_with_resources')( context, data_dict )

    return packages[:4]

def random_int():
    try:
        from random import randint
        return randint(0,500)
    except:
        log.error("There were a problem generating a random integer")

def resource_file_name( resource ):
    if resource["url"]:
        resource_split = resource["url"].split('/')
        return resource_split[len(resource_split)-1]

def get_preview_image( package ):
    preview_image = "/img/dataset.png"
    if 'resources' in package:
        print( package['resources'])
        for resource in package['resources']:
            data_dict={ 'id': resource["id"] }
            views = toolkit.get_action('resource_view_list')({},data_dict)
            for view in views:
                if 'view_type' in view and view['view_type']=='image_view':
                    if resource['name']=='Imagen destacada':
                        return resource['url']
    return preview_image

def get_state_tracking():
    return "True"

def get_downloads_count( id ):
    count = 0
    data_dict={ 'id':id, 'include_tracking': True }
    package = toolkit.get_action('package_show')( {}, data_dict )
    if 'resources' in package:
        for resource in package['resources']:
            if 'tracking_summary' in resource:
                if isinstance(resource['tracking_summary']['total'],int):
                    count +=resource['tracking_summary']['total'];
    return count

def get_views_count( id ):
    count = 0
    data_dict={ 'id':id, 'include_tracking': True }
    package = toolkit.get_action('package_show')( {}, data_dict )
    if 'resources' in package:
        if 'tracking_summary' in package:
            if isinstance(package['tracking_summary']['total'],int):
                count +=package['tracking_summary']['total'];
    return count