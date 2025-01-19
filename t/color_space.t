use strict;
use warnings;

use Test::More;
use PDL::LiteF;
use PDL::Graphics::ColorSpace;
use Test::PDL;

# rgb_to_hsl   hsl_to_rgb
{   
	my $rgb = pdl( [255,255,255],[0,0,0],[255,10,50],[1,48,199] ) / 255;
	my $hsl = pdl( [0,0,1], [0,0,0], [350.204081632653,1,0.519607843137255], [225.757575757576,0.99,0.392156862745098] );

	my $a_hsl = rgb_to_hsl( $rgb );
	is_pdl $a_hsl, $hsl, 'rgb_to_hsl';

	my $a_rgb = hsl_to_rgb( $hsl );
	is_pdl $a_rgb, $rgb, 'hsl_to_rgb';

	my $rgb_bad   = $rgb->copy->setbadat(1,2);
	my $a_hsl_bad = rgb_to_hsl($rgb_bad);
	is_pdl $a_hsl_bad, pdl('0 0 1; 0 0 0; BAD BAD BAD; 225.75758 0.99 0.39215686'), 'rgb_to_hsl with bad value';

	my $hsl_bad   = $hsl->copy->setbadat(0,3);
	my $a_rgb_bad = hsl_to_rgb($hsl_bad);
	is_pdl $a_rgb_bad, pdl('1 1 1; 0 0 0; 1 0.039215686 0.19607843; BAD BAD BAD'), 'hsl_to_rgb with bad value';
}

# rgb_to_cmyk   cmyk_to_rgb
{   
	my $rgb = pdl( [255,255,255],[0,0,0],[255,10,50],[1,48,199] ) / 255;
	my $cmyk = pdl(
		[0,0,0,0],
		[0,0,0,1],
		[0,0.960784313725491,0.803921568627451,1.11022302462516e-16],
		[0.776470588235295, 0.592156862745098, 0, 0.219607843137255]
	);

	my $a_cmyk = rgb_to_cmyk( $rgb );
	is_pdl $a_cmyk, $cmyk, 'rgb_to_cmyk';

	my $a_rgb = cmyk_to_rgb( $cmyk );
	is_pdl $a_rgb, $rgb, 'cmyk_to_rgb';

	my $rgb_bad   = $rgb->copy->setbadat(1,2);
	my $a_cmyk_bad = rgb_to_cmyk($rgb_bad);
	is_pdl $a_cmyk_bad, pdl('0 0 0 0; 0 0 0 1; BAD BAD BAD BAD; 0.77647059 0.59215686 0 0.21960784'), 'rgb_to_cmyk with bad value';

	my $cmyk_bad   = $cmyk->copy->setbadat(0,3);
	my $a_rgb_bad = cmyk_to_rgb($cmyk_bad);
	is_pdl $a_rgb_bad, pdl('1 1 1; 0 0 0; 1 0.039215686 0.19607843; BAD BAD BAD'), 'cmyk_to_rgb with bad value';
}

# rgb_to_hsv   hsv_to_rgb
{   
	my $rgb = pdl( [255,255,255],[0,0,0],[255,10,50],[1,48,199] ) / 255;
	my $hsv = pdl( [0,0,1], [0,0,0], [350.204081632653,0.960784313725491,1], [225.757575757576,0.994974874371861,0.780392156862745] );

	my $a_hsv = rgb_to_hsv( $rgb );
	is_pdl $a_hsv, $hsv, 'rgb_to_hsv';

	my $a_rgb = hsv_to_rgb( $hsv );
	is_pdl $a_rgb, $rgb, 'hsv_to_rgb';

	my $rgb_bad   = $rgb->copy->setbadat(1,2);
	my $a_hsv_bad = rgb_to_hsv($rgb_bad);
	is_pdl $a_hsv_bad, pdl('0 0 1; 0 0 0; BAD BAD BAD; 225.75758 0.99497487 0.78039216'), 'rgb_to_hsv with bad value';

	my $hsv_bad   = $hsv->copy->setbadat(0,3);
	my $a_rgb_bad = hsv_to_rgb($hsv_bad);
	is_pdl $a_rgb_bad, pdl('1 1 1; 0 0 0; 1 0.039215686 0.19607843; BAD BAD BAD'), 'hsv_to_rgb with bad value';
}

# rgb_to_xyz and rgb_{to,from}_linear
{   
	my $rgb = pdl( [255,255,255],[0,0,0],[255,10,50],[1,48,199] ) / 255;
	my $xyz = pdl( [0.950467757575757, 1, 1.08897436363636],
	  [0,0,0],
	  [0.419265223936783, 0.217129144548417, 0.0500096992920757],
	  [0.113762127389896, 0.0624295703768394, 0.546353858701224] );
	my $linear_ans = pdl( [1,1,1],[0,0,0],
	  [1, 0.0030352698, 0.031896033],
	  [0.00030352698, 0.029556834, 0.57112483] );

	my $a_xyz = rgb_to_xyz( $rgb, 'sRGB' );
	is_pdl $a_xyz, $xyz, 'rgb_to_xyz sRGB';

	my $rgb_linear = rgb_to_linear($rgb, -1);
	is_pdl $rgb_linear, $linear_ans, 'rgb_to_linear sRGB';
	my $rgb_regamma = rgb_from_linear($rgb_linear, -1);
	is_pdl $rgb_regamma, $rgb, 're-rgb_from_linear sRGB';
	my $a2_xyz = rgb_to_xyz( $rgb_linear, 'lsRGB' );
	is_pdl $a2_xyz, $xyz, 'rgb_to_xyz lsRGB';

	my $a_rgb = xyz_to_rgb( $xyz, 'sRGB' );
	is_pdl $a_rgb, $rgb, 'xyz_to_rgb sRGB';

	my $rgb_ = pdl(255, 10, 50) / 255;
	my $a = rgb_to_xyz( $rgb_, 'Adobe' );
	my $ans = pdl( 0.582073320819542, 0.299955362786115, 0.0546021884576833 ); 
	is_pdl $a, $ans, 'rgb_to_xyz Adobe';
	$rgb_->inplace->rgb_to_xyz( 'Adobe' );
	is_pdl $rgb_, $ans, 'rgb_to_xyz inplace';
}

# xyY_to_xyz
{
	my $xyY = pdl(0.312713, 0.329016, 1);
	my $a   = xyY_to_xyz($xyY);
	my $ans = pdl(0.950449218275099, 1, 1.08891664843047);
	is_pdl $a, $ans, 'xyY_to_xyz';
}


# xyz_to_lab  lab_to_xyz
{
	my $xyz = pdl([0.4, 0.2, 0.02], [0,0,1]);
	my $lab = pdl([51.8372115265385, 82.2953523409701, 64.1921650722979], [0,0,-166.814773017556]);

	my $a_lab = $xyz->xyz_to_lab('sRGB');
	is_pdl $a_lab, $lab, 'xyz_to_lab sRGB';

	my $a_xyz = $lab->lab_to_xyz('sRGB');
	is_pdl $a_xyz, $xyz, 'lab_to_xyz sRGB';
	$a_xyz = $lab->lab_to_xyz($PDL::Graphics::ColorSpace::RGBSpace::RGB_SPACE->{sRGB});
	is_pdl $a_xyz, $xyz, 'lab_to_xyz with hash-ref';

	my $xyz_bad = $xyz->copy;
	$xyz_bad->setbadat(0,1);
	$a_lab = $xyz_bad->xyz_to_lab('sRGB');
	is_pdl $a_lab, pdl('51.837212 82.295352 64.192165; BAD BAD BAD'), 'xyz_to_lab sRGB with bad value';

	my $lab_bad = $lab->copy;
	$lab_bad->setbadat(0,1);
	$a_xyz = $lab_bad->lab_to_xyz('sRGB');
	is_pdl $a_xyz, pdl('0.4 0.2 0.02; BAD BAD BAD'), 'lab_to_xyz sRGB with bad value';
}


# lab_to_lch and lch_to_lab
{
	my $lab = pdl([53.380244, 79.817473, 64.822569], [0,0,1]);
	my $lch = pdl([53.380244, 102.824094685368, 39.081262060261], [0,1,90]);

	my $a_lch = lab_to_lch($lab);
	is_pdl $a_lch, $lch, 'lab_to_lch';

	my $a_lab = lch_to_lab($lch);
	is_pdl $a_lab, $lab, 'lch_to_lab';
}

# rgb_to_lch
{
	my $rgb = pdl([25, 10, 243], [0,0,1]) / 255;
	my $lch = pdl([31.5634666908367, 126.828356633829, 306.221274674578],
		          [ 0.0197916632671635, 0.403227926549451, 290.177020167939 ]);

	my $a_lch = rgb_to_lch($rgb, 'sRGB');
	is_pdl $a_lch, $lch, 'rgb_to_lch sRGB';

	my $a_rgb = lch_to_rgb($lch, 'sRGB');
	is_pdl $a_rgb, $rgb, 'lch_to_rgb sRGB';

	my $rgb_bad = $rgb->copy;
	$rgb_bad->setbadat(1,1);
	$a_lch = $rgb_bad->rgb_to_lch('sRGB');
	is_pdl $a_lch, pdl('31.563467 126.82836 306.22127; BAD BAD BAD'), 'rgb_to_lch sRGB with bad value';

	my $lch_bad = $lch->copy;
	$lch_bad->setbadat(1,1);
	$a_rgb = $lch_bad->lch_to_rgb('sRGB');
	is_pdl $a_rgb, pdl('0.098039216 0.039215686 0.95294118; BAD BAD BAD'), 'lch_to_rgb sRGB with bad value';
}

# rgb_to_lab
{
	my $rgb = pdl([25, 10, 243], [0,0,1]) / 255;
	my $lab = pdl([31.5634666908367, 74.943543, -102.31763],
		          [ 0.0197916632671635, 0.13908209, -0.37848241]);

	my $a_lab = rgb_to_lab($rgb, 'sRGB');
	is_pdl $a_lab, $lab, 'rgb_to_lab sRGB';

	my $a_rgb = lab_to_rgb($lab, 'sRGB');
	is_pdl $a_rgb, $rgb, 'lab_to_rgb sRGB';

	my $rgb_bad = $rgb->copy;
	$rgb_bad->setbadat(1,1);
	$a_lab = $rgb_bad->rgb_to_lab('sRGB');
	is_pdl $a_lab, pdl('31.563467 74.943543 -102.31763; BAD BAD BAD'), 'rgb_to_lab sRGB with bad value';

	my $lab_bad = $lab->copy;
	$lab_bad->setbadat(1,1);
	$a_rgb = $lab_bad->lab_to_rgb('sRGB');
	is_pdl $a_rgb, pdl('0.098039195 0.039215694 0.95294118; BAD BAD BAD'), 'lab_to_rgb sRGB with bad value';
}

# add_rgb_space
{
	my %custom_space = (
		custom_1 => {
          'gamma' => '2.2',
          'm' => [
                   [
                     '0.467384242424242',
                     '0.240995',
                     '0.0219086363636363'
                   ],
                   [
                     '0.294454030769231',
                     '0.683554',
                     '0.0736135076923076'
                   ],
                   [
                     '0.18863',
                     '0.075452',
                     '0.993451333333334'
                   ]
                 ],
          'white_point' => [
                             '0.312713',
                             '0.329016'
                           ],
		},
	);

	PDL::Graphics::ColorSpace::add_rgb_space( \%custom_space );

	my $rgb = pdl([25, 10, 243], [0,0,1]) / 255;

	# custom_1 is in fact copied from BruceRGB
	my $a_lch = rgb_to_lch($rgb, 'BruceRGB');
	my $lch = rgb_to_lch($rgb, 'custom_1');
	is_pdl $a_lch, $lch, 'rgb_to_lch with add_rgb_space';
	eval {PDL::Graphics::ColorSpace::add_rgb_space( \%custom_space )};
        like $@, qr/existing/, 'add duplicate croaks';
}

done_testing();
