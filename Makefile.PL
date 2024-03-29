use strict;
use warnings;
use PDL::Core::Dev;
use ExtUtils::MakeMaker;

my $pack = [qw(color_space.pd ColorSpace PDL::Graphics::ColorSpace), undef, 1];
my %hash = pdlpp_stdargs($pack);
$hash{OBJECT} .= ' color_space$(OBJ_EXT)';
$hash{clean}{FILES} .= ' color_space$(OBJ_EXT)';

WriteMakefile( %hash,
    AUTHOR              => 'Maggie J. Xiong  <maggiexyz+github gmail.com>',
    PM => {
      'ColorSpace.pm'           => '$(INST_LIBDIR)/ColorSpace.pm',
      'ColorSpace/RGBSpace.pm'  => '$(INST_LIBDIR)/ColorSpace/RGBSpace.pm',
    },
    CONFIGURE_REQUIRES => {
        'PDL'        => '2.074', # multi-C etc
    },
    TEST_REQUIRES => {
        'Test::More' => '0.88',
    },
    PREREQ_PM => {
        'PDL'        => '2.074', # multi-C etc
    },
    META_MERGE => {
       "meta-spec" => { version => 2 },
       resources => {
          bugtracker  => {web=>'https://github.com/PDLPorters/PDL-Graphics-ColorSpace/issues'},
          repository  => {
             url => 'git://github.com/PDLPorters/PDL-Graphics-ColorSpace.git',
             type => 'git',
             web => 'https://github.com/PDLPorters/PDL-Graphics-ColorSpace',
          },
          x_IRC => 'irc://irc.perl.org/#pdl',
       },
    },
);

sub MY::postamble {pdlpp_postamble($pack)};
