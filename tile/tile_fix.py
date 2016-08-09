import yaml
import os


manifest_path = os.path.join('product', 'metadata', 'splunk.yml')
with open(manifest_path) as manifest_file:
	manifest = yaml.safe_load(manifest_file)

manifest['releases'] = [release for release in manifest['releases'] if release['name'] != 'splunk']
manifest['job_types'] = [
	job_type for job_type in manifest['job_types']
	if job_type['name'] != 'deploy-all' and job_type['name'] != 'delete-all'
]
manifest['post_deploy_errands'] = [
	errand for errand in manifest['post_deploy_errands'] if errand['name'] != 'deploy-all'
]
manifest['pre_delete_errands'] = [
	errand for errand in manifest['pre_delete_errands'] if errand['name'] != 'delete-all'
]

customized_path = os.path.join('product', 'metadata', 'custom.yml')
with open(customized_path, 'wb') as customized_file:
	customized_file.write('---\n')
	customized_file.write(yaml.safe_dump(manifest, default_flow_style=False))
