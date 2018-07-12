import ckan.plugins as plugins
import ckan.plugins.toolkit as toolkit


class Ider_ThemePlugin(plugins.SingletonPlugin):
    plugins.implements(plugins.IConfigurer)
    plugins.implements(plugins.ITemplateHelpers)

    # IConfigurer

    def update_config(self, config_):
        toolkit.add_template_directory(config_, 'templates')
        toolkit.add_public_directory(config_, 'public')
        toolkit.add_resource('fanstatic', 'ider_theme')

    def get_helpers(self):
        import helpers
        return {
            'all_groups': helpers.all_groups,
            'all_packages': helpers.all_packages,
            'random_int': helpers.random_int,
            'resource_file_name': helpers.resource_file_name,
            'get_preview_image': helpers.get_preview_image,
            'get_state_tracking': helpers.get_state_tracking,
            'get_downloads_count': helpers.get_downloads_count,
            'get_views_count': helpers.get_views_count,
        }
