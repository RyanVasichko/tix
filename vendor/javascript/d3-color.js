function define(t,e,r){t.prototype=e.prototype=r;r.constructor=t}function extend(t,e){var r=Object.create(t.prototype);for(var n in e)r[n]=e[n];return r}function Color(){}var t=.7;var e=1/t;var r="\\s*([+-]?\\d+)\\s*",n="\\s*([+-]?(?:\\d*\\.)?\\d+(?:[eE][+-]?\\d+)?)\\s*",i="\\s*([+-]?(?:\\d*\\.)?\\d+(?:[eE][+-]?\\d+)?)%\\s*",a=/^#([0-9a-f]{3,8})$/,l=new RegExp(`^rgb\\(${r},${r},${r}\\)$`),o=new RegExp(`^rgb\\(${i},${i},${i}\\)$`),h=new RegExp(`^rgba\\(${r},${r},${r},${n}\\)$`),s=new RegExp(`^rgba\\(${i},${i},${i},${n}\\)$`),c=new RegExp(`^hsl\\(${n},${i},${i}\\)$`),b=new RegExp(`^hsla\\(${n},${i},${i},${n}\\)$`);var u={aliceblue:15792383,antiquewhite:16444375,aqua:65535,aquamarine:8388564,azure:15794175,beige:16119260,bisque:16770244,black:0,blanchedalmond:16772045,blue:255,blueviolet:9055202,brown:10824234,burlywood:14596231,cadetblue:6266528,chartreuse:8388352,chocolate:13789470,coral:16744272,cornflowerblue:6591981,cornsilk:16775388,crimson:14423100,cyan:65535,darkblue:139,darkcyan:35723,darkgoldenrod:12092939,darkgray:11119017,darkgreen:25600,darkgrey:11119017,darkkhaki:12433259,darkmagenta:9109643,darkolivegreen:5597999,darkorange:16747520,darkorchid:10040012,darkred:9109504,darksalmon:15308410,darkseagreen:9419919,darkslateblue:4734347,darkslategray:3100495,darkslategrey:3100495,darkturquoise:52945,darkviolet:9699539,deeppink:16716947,deepskyblue:49151,dimgray:6908265,dimgrey:6908265,dodgerblue:2003199,firebrick:11674146,floralwhite:16775920,forestgreen:2263842,fuchsia:16711935,gainsboro:14474460,ghostwhite:16316671,gold:16766720,goldenrod:14329120,gray:8421504,green:32768,greenyellow:11403055,grey:8421504,honeydew:15794160,hotpink:16738740,indianred:13458524,indigo:4915330,ivory:16777200,khaki:15787660,lavender:15132410,lavenderblush:16773365,lawngreen:8190976,lemonchiffon:16775885,lightblue:11393254,lightcoral:15761536,lightcyan:14745599,lightgoldenrodyellow:16448210,lightgray:13882323,lightgreen:9498256,lightgrey:13882323,lightpink:16758465,lightsalmon:16752762,lightseagreen:2142890,lightskyblue:8900346,lightslategray:7833753,lightslategrey:7833753,lightsteelblue:11584734,lightyellow:16777184,lime:65280,limegreen:3329330,linen:16445670,magenta:16711935,maroon:8388608,mediumaquamarine:6737322,mediumblue:205,mediumorchid:12211667,mediumpurple:9662683,mediumseagreen:3978097,mediumslateblue:8087790,mediumspringgreen:64154,mediumturquoise:4772300,mediumvioletred:13047173,midnightblue:1644912,mintcream:16121850,mistyrose:16770273,moccasin:16770229,navajowhite:16768685,navy:128,oldlace:16643558,olive:8421376,olivedrab:7048739,orange:16753920,orangered:16729344,orchid:14315734,palegoldenrod:15657130,palegreen:10025880,paleturquoise:11529966,palevioletred:14381203,papayawhip:16773077,peachpuff:16767673,peru:13468991,pink:16761035,plum:14524637,powderblue:11591910,purple:8388736,rebeccapurple:6697881,red:16711680,rosybrown:12357519,royalblue:4286945,saddlebrown:9127187,salmon:16416882,sandybrown:16032864,seagreen:3050327,seashell:16774638,sienna:10506797,silver:12632256,skyblue:8900331,slateblue:6970061,slategray:7372944,slategrey:7372944,snow:16775930,springgreen:65407,steelblue:4620980,tan:13808780,teal:32896,thistle:14204888,tomato:16737095,turquoise:4251856,violet:15631086,wheat:16113331,white:16777215,whitesmoke:16119285,yellow:16776960,yellowgreen:10145074};define(Color,color,{copy(t){return Object.assign(new this.constructor,this,t)},displayable(){return this.rgb().displayable()},hex:color_formatHex,formatHex:color_formatHex,formatHex8:color_formatHex8,formatHsl:color_formatHsl,formatRgb:color_formatRgb,toString:color_formatRgb});function color_formatHex(){return this.rgb().formatHex()}function color_formatHex8(){return this.rgb().formatHex8()}function color_formatHsl(){return hslConvert(this).formatHsl()}function color_formatRgb(){return this.rgb().formatRgb()}function color(t){var e,r;t=(t+"").trim().toLowerCase();return(e=a.exec(t))?(r=e[1].length,e=parseInt(e[1],16),6===r?rgbn(e):3===r?new Rgb(e>>8&15|e>>4&240,e>>4&15|240&e,(15&e)<<4|15&e,1):8===r?rgba(e>>24&255,e>>16&255,e>>8&255,(255&e)/255):4===r?rgba(e>>12&15|e>>8&240,e>>8&15|e>>4&240,e>>4&15|240&e,((15&e)<<4|15&e)/255):null):(e=l.exec(t))?new Rgb(e[1],e[2],e[3],1):(e=o.exec(t))?new Rgb(255*e[1]/100,255*e[2]/100,255*e[3]/100,1):(e=h.exec(t))?rgba(e[1],e[2],e[3],e[4]):(e=s.exec(t))?rgba(255*e[1]/100,255*e[2]/100,255*e[3]/100,e[4]):(e=c.exec(t))?hsla(e[1],e[2]/100,e[3]/100,1):(e=b.exec(t))?hsla(e[1],e[2]/100,e[3]/100,e[4]):u.hasOwnProperty(t)?rgbn(u[t]):"transparent"===t?new Rgb(NaN,NaN,NaN,0):null}function rgbn(t){return new Rgb(t>>16&255,t>>8&255,255&t,1)}function rgba(t,e,r,n){n<=0&&(t=e=r=NaN);return new Rgb(t,e,r,n)}function rgbConvert(t){t instanceof Color||(t=color(t));if(!t)return new Rgb;t=t.rgb();return new Rgb(t.r,t.g,t.b,t.opacity)}function rgb(t,e,r,n){return 1===arguments.length?rgbConvert(t):new Rgb(t,e,r,null==n?1:n)}function Rgb(t,e,r,n){this.r=+t;this.g=+e;this.b=+r;this.opacity=+n}define(Rgb,rgb,extend(Color,{brighter(t){t=null==t?e:Math.pow(e,t);return new Rgb(this.r*t,this.g*t,this.b*t,this.opacity)},darker(e){e=null==e?t:Math.pow(t,e);return new Rgb(this.r*e,this.g*e,this.b*e,this.opacity)},rgb(){return this},clamp(){return new Rgb(clampi(this.r),clampi(this.g),clampi(this.b),clampa(this.opacity))},displayable(){return-.5<=this.r&&this.r<255.5&&-.5<=this.g&&this.g<255.5&&-.5<=this.b&&this.b<255.5&&0<=this.opacity&&this.opacity<=1},hex:rgb_formatHex,formatHex:rgb_formatHex,formatHex8:rgb_formatHex8,formatRgb:rgb_formatRgb,toString:rgb_formatRgb}));function rgb_formatHex(){return`#${hex(this.r)}${hex(this.g)}${hex(this.b)}`}function rgb_formatHex8(){return`#${hex(this.r)}${hex(this.g)}${hex(this.b)}${hex(255*(isNaN(this.opacity)?1:this.opacity))}`}function rgb_formatRgb(){const t=clampa(this.opacity);return`${1===t?"rgb(":"rgba("}${clampi(this.r)}, ${clampi(this.g)}, ${clampi(this.b)}${1===t?")":`, ${t})`}`}function clampa(t){return isNaN(t)?1:Math.max(0,Math.min(1,t))}function clampi(t){return Math.max(0,Math.min(255,Math.round(t)||0))}function hex(t){t=clampi(t);return(t<16?"0":"")+t.toString(16)}function hsla(t,e,r,n){n<=0?t=e=r=NaN:r<=0||r>=1?t=e=NaN:e<=0&&(t=NaN);return new Hsl(t,e,r,n)}function hslConvert(t){if(t instanceof Hsl)return new Hsl(t.h,t.s,t.l,t.opacity);t instanceof Color||(t=color(t));if(!t)return new Hsl;if(t instanceof Hsl)return t;t=t.rgb();var e=t.r/255,r=t.g/255,n=t.b/255,i=Math.min(e,r,n),a=Math.max(e,r,n),l=NaN,o=a-i,h=(a+i)/2;if(o){l=e===a?(r-n)/o+6*(r<n):r===a?(n-e)/o+2:(e-r)/o+4;o/=h<.5?a+i:2-a-i;l*=60}else o=h>0&&h<1?0:l;return new Hsl(l,o,h,t.opacity)}function hsl(t,e,r,n){return 1===arguments.length?hslConvert(t):new Hsl(t,e,r,null==n?1:n)}function Hsl(t,e,r,n){this.h=+t;this.s=+e;this.l=+r;this.opacity=+n}define(Hsl,hsl,extend(Color,{brighter(t){t=null==t?e:Math.pow(e,t);return new Hsl(this.h,this.s,this.l*t,this.opacity)},darker(e){e=null==e?t:Math.pow(t,e);return new Hsl(this.h,this.s,this.l*e,this.opacity)},rgb(){var t=this.h%360+360*(this.h<0),e=isNaN(t)||isNaN(this.s)?0:this.s,r=this.l,n=r+(r<.5?r:1-r)*e,i=2*r-n;return new Rgb(hsl2rgb(t>=240?t-240:t+120,i,n),hsl2rgb(t,i,n),hsl2rgb(t<120?t+240:t-120,i,n),this.opacity)},clamp(){return new Hsl(clamph(this.h),clampt(this.s),clampt(this.l),clampa(this.opacity))},displayable(){return(0<=this.s&&this.s<=1||isNaN(this.s))&&0<=this.l&&this.l<=1&&0<=this.opacity&&this.opacity<=1},formatHsl(){const t=clampa(this.opacity);return`${1===t?"hsl(":"hsla("}${clamph(this.h)}, ${100*clampt(this.s)}%, ${100*clampt(this.l)}%${1===t?")":`, ${t})`}`}}));function clamph(t){t=(t||0)%360;return t<0?t+360:t}function clampt(t){return Math.max(0,Math.min(1,t||0))}function hsl2rgb(t,e,r){return 255*(t<60?e+(r-e)*t/60:t<180?r:t<240?e+(r-e)*(240-t)/60:e)}const g=Math.PI/180;const p=180/Math.PI;const f=18,m=.96422,d=1,y=.82521,w=4/29,x=6/29,$=3*x*x,v=x*x*x;function labConvert(t){if(t instanceof Lab)return new Lab(t.l,t.a,t.b,t.opacity);if(t instanceof Hcl)return hcl2lab(t);t instanceof Rgb||(t=rgbConvert(t));var e,r,n=rgb2lrgb(t.r),i=rgb2lrgb(t.g),a=rgb2lrgb(t.b),l=xyz2lab((.2225045*n+.7168786*i+.0606169*a)/d);if(n===i&&i===a)e=r=l;else{e=xyz2lab((.4360747*n+.3850649*i+.1430804*a)/m);r=xyz2lab((.0139322*n+.0971045*i+.7141733*a)/y)}return new Lab(116*l-16,500*(e-l),200*(l-r),t.opacity)}function gray(t,e){return new Lab(t,0,0,null==e?1:e)}function lab(t,e,r,n){return 1===arguments.length?labConvert(t):new Lab(t,e,r,null==n?1:n)}function Lab(t,e,r,n){this.l=+t;this.a=+e;this.b=+r;this.opacity=+n}define(Lab,lab,extend(Color,{brighter(t){return new Lab(this.l+f*(null==t?1:t),this.a,this.b,this.opacity)},darker(t){return new Lab(this.l-f*(null==t?1:t),this.a,this.b,this.opacity)},rgb(){var t=(this.l+16)/116,e=isNaN(this.a)?t:t+this.a/500,r=isNaN(this.b)?t:t-this.b/200;e=m*lab2xyz(e);t=d*lab2xyz(t);r=y*lab2xyz(r);return new Rgb(lrgb2rgb(3.1338561*e-1.6168667*t-.4906146*r),lrgb2rgb(-.9787684*e+1.9161415*t+.033454*r),lrgb2rgb(.0719453*e-.2289914*t+1.4052427*r),this.opacity)}}));function xyz2lab(t){return t>v?Math.pow(t,1/3):t/$+w}function lab2xyz(t){return t>x?t*t*t:$*(t-w)}function lrgb2rgb(t){return 255*(t<=.0031308?12.92*t:1.055*Math.pow(t,1/2.4)-.055)}function rgb2lrgb(t){return(t/=255)<=.04045?t/12.92:Math.pow((t+.055)/1.055,2.4)}function hclConvert(t){if(t instanceof Hcl)return new Hcl(t.h,t.c,t.l,t.opacity);t instanceof Lab||(t=labConvert(t));if(0===t.a&&0===t.b)return new Hcl(NaN,0<t.l&&t.l<100?0:NaN,t.l,t.opacity);var e=Math.atan2(t.b,t.a)*p;return new Hcl(e<0?e+360:e,Math.sqrt(t.a*t.a+t.b*t.b),t.l,t.opacity)}function lch(t,e,r,n){return 1===arguments.length?hclConvert(t):new Hcl(r,e,t,null==n?1:n)}function hcl(t,e,r,n){return 1===arguments.length?hclConvert(t):new Hcl(t,e,r,null==n?1:n)}function Hcl(t,e,r,n){this.h=+t;this.c=+e;this.l=+r;this.opacity=+n}function hcl2lab(t){if(isNaN(t.h))return new Lab(t.l,0,0,t.opacity);var e=t.h*g;return new Lab(t.l,Math.cos(e)*t.c,Math.sin(e)*t.c,t.opacity)}define(Hcl,hcl,extend(Color,{brighter(t){return new Hcl(this.h,this.c,this.l+f*(null==t?1:t),this.opacity)},darker(t){return new Hcl(this.h,this.c,this.l-f*(null==t?1:t),this.opacity)},rgb(){return hcl2lab(this).rgb()}}));var H=-.14861,N=1.78277,k=-.29227,R=-.90649,C=1.97294,M=C*R,_=C*N,L=N*k-R*H;function cubehelixConvert(t){if(t instanceof Cubehelix)return new Cubehelix(t.h,t.s,t.l,t.opacity);t instanceof Rgb||(t=rgbConvert(t));var e=t.r/255,r=t.g/255,n=t.b/255,i=(L*n+M*e-_*r)/(L+M-_),a=n-i,l=(C*(r-i)-k*a)/R,o=Math.sqrt(l*l+a*a)/(C*i*(1-i)),h=o?Math.atan2(l,a)*p-120:NaN;return new Cubehelix(h<0?h+360:h,o,i,t.opacity)}function cubehelix(t,e,r,n){return 1===arguments.length?cubehelixConvert(t):new Cubehelix(t,e,r,null==n?1:n)}function Cubehelix(t,e,r,n){this.h=+t;this.s=+e;this.l=+r;this.opacity=+n}define(Cubehelix,cubehelix,extend(Color,{brighter(t){t=null==t?e:Math.pow(e,t);return new Cubehelix(this.h,this.s,this.l*t,this.opacity)},darker(e){e=null==e?t:Math.pow(t,e);return new Cubehelix(this.h,this.s,this.l*e,this.opacity)},rgb(){var t=isNaN(this.h)?0:(this.h+120)*g,e=+this.l,r=isNaN(this.s)?0:this.s*e*(1-e),n=Math.cos(t),i=Math.sin(t);return new Rgb(255*(e+r*(H*n+N*i)),255*(e+r*(k*n+R*i)),255*(e+r*(C*n)),this.opacity)}}));export{color,cubehelix,gray,hcl,hsl,lab,lch,rgb};

