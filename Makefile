help: ## Display list of targets and their documentation
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk \
		'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

r10k:
	r10k deploy module -c r10k.yaml -v

rsync:
#	rsync -rav --delete-after --no-owner site hieradata hiera.yaml Puppetfile root@static.zumbi.com.ar:/srv/puppet-apply/
	rsync -rav --delete-after --no-owner site hieradata hiera.yaml Puppetfile root@pi:/srv/puppet-apply/

apply: rsync ## Apply puppet on all hosts
#	ssh root@static.zumbi.com.ar "puppet apply --show_diff --verbose --modulepath=/srv/puppet-apply/site:/srv/puppet-apply/modules /srv/puppet-apply/site/site.pp ; rm -rf /srv/puppet-apply/hieradata"
#	ssh root@mail.zumbi.com.ar "puppet apply"
#	ssh root@tor2 "puppet apply"
	ssh root@pi "cd /srv/puppet-apply ; puppet apply --show_diff --verbose --confdir /srv/puppet-apply --modulepath=/srv/puppet-apply/site:/srv/puppet-apply/modules /srv/puppet-apply/site/site.pp ; rm -rf /srv/puppet-apply/hieradata"
#	ssh root@casa.motok.com.ar "puppet apply"
