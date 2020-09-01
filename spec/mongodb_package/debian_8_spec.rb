require 'spec_helper'

describe 'mongodb-lib-spec::mongodb_package' do
  context 'on Debian (8)' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'debian',
        version: '8.8',
        step_into: 'mongodb_package'
      ).converge described_recipe
    end

    it 'installs package without version' do
      expect(chef_run).to install_mongodb_package('mongodb-org-without-version')
    end

    %w(mongodb-org-server mongodb-org-shell mongodb-org-mongos mongodb-org-tools).each do |pkg|
      it "removes remove-#{pkg} package" do
        expect(chef_run).to remove_mongodb_package("remove-#{pkg}")
      end

      it "installs #{pkg} package 12.34.56" do
        expect(chef_run).to install_mongodb_package(pkg).with(version: '12.34.56')
      end

      context 'step into mongodb_package' do
        it 'installs package without version' do
          expect(chef_run).to install_package('mongodb-org-without-version')
        end

        it "removes remove-#{pkg} package" do
          expect(chef_run).to remove_package("remove-#{pkg}")
        end

        it "installs #{pkg} package 12.34.56" do
          expect(chef_run).to install_package(pkg).with(version: '12.34.56')
        end
      end
    end
  end
end
