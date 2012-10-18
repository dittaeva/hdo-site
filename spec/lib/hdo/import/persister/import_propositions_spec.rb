require 'spec_helper'

module Hdo
  module Import
    describe Persister do
      context 'propositions' do

        include_context :persister

        def setup_proposition(prop)
          rep = prop.delivered_by
          rep.parties.each { |p| Party.make!(external_id: p.external_id) }
          rep.committees.each { |c| Committee.make!(external_id: c.external_id) }
          District.make!(name: rep.district)
        end

        it 'imports a proposition' do
          example = StortingImporter::Proposition.example
          setup_proposition example

          persister.import_propositions [example]
          Proposition.count.should == 1

          prop = Proposition.first
          prop.delivered_by.should be_kind_of(Representative)
        end

        # https://github.com/holderdeord/hdo-site/issues/138
        it 'imports a proposition with external_id -1' do
          prop = StortingImporter::Proposition.example('externalId' => '-1')
          setup_proposition(prop)

          persister.import_propositions [prop]
          Proposition.count.should == 1

          imported = Proposition.first
          imported.external_id.should be_nil
        end

        it 'ignores propositions with external_id=-1, body="" and description=""' do
          prop = Hdo::StortingImporter::Proposition.example(
            'externalId'  => '-1',
            'body'        => '',
            'description' => ''
          )

          persister.import_propositions [prop]

          Proposition.count.should == 0
        end

      end
    end
  end
end
