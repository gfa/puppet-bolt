help: ## Display list of targets and their documentation
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk \
		'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

r10k: ## install modules with r10k
	r10k puppetfile install

rsync: ## rsync puppet data to machines
#	rsync -rav --delete-after --no-owner site hieradata hiera.yaml Puppetfile root@static.zumbi.com.ar:/srv/puppet-apply/
	rsync -rav --delete-after --no-owner --cvs-exclude --exclude=.gem --exclude=var . root@35.235.68.197:/srv/puppet-apply/
#	rsync -rav --delete-after --no-owner --cvs-exclude --exclude=.gem --exclude=var . root@pi:/srv/puppet-apply/

apply: rsync ## Apply puppet on all hosts
	ssh root@35.235.68.197 "cd /srv/puppet-apply ; puppet apply --show_diff --verbose --confdir /srv/puppet-apply --codedir /srv/puppet-apply --modulepath=/srv/puppet-apply/site:/srv/puppet-apply/modules /srv/puppet-apply/site/site.pp ; rm -rf /srv/puppet-apply/hieradata"
#	ssh root@pi "cd /srv/puppet-apply ; puppet apply --show_diff --verbose --confdir /srv/puppet-apply --modulepath=/srv/puppet-apply/site:/srv/puppet-apply/modules /srv/puppet-apply/site/site.pp"

debug: rsync ## Apply puppet on all hosts
	ssh root@35.235.68.197 "cd /srv/puppet-apply ; puppet apply --noop --show_diff --verbose --debug --confdir /srv/puppet-apply --codedir /srv/puppet-apply --modulepath=/srv/puppet-apply/site:/srv/puppet-apply/modules /srv/puppet-apply/site/site.pp ; rm -rf /srv/puppet-apply/hieradata"
#	ssh root@pi "cd /srv/puppet-apply ; puppet apply --show_diff --verbose --debug --confdir /srv/puppet-apply --modulepath=/srv/puppet-apply/site:/srv/puppet-apply/modules /srv/puppet-apply/site/site.pp"
