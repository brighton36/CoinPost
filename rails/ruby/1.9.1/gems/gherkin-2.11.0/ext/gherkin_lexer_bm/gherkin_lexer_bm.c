
#line 1 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
#include <assert.h>
#include <ruby.h>

#if defined(_WIN32)
#include <stddef.h>
#endif

#ifdef HAVE_RUBY_RE_H
#include <ruby/re.h>
#else
#include <re.h>
#endif

#ifdef HAVE_RUBY_ENCODING_H
#include <ruby/encoding.h>
#define ENCODED_STR_NEW(ptr, len) \
    rb_enc_str_new(ptr, len, rb_utf8_encoding())
#else
#define ENCODED_STR_NEW(ptr, len) \
    rb_str_new(ptr, len)
#endif

#ifndef RSTRING_PTR
#define RSTRING_PTR(s) (RSTRING(s)->ptr)
#endif

#ifndef RSTRING_LEN
#define RSTRING_LEN(s) (RSTRING(s)->len)
#endif

#define DATA_GET(FROM, TYPE, NAME) \
  Data_Get_Struct(FROM, TYPE, NAME); \
  if (NAME == NULL) { \
    rb_raise(rb_eArgError, "NULL found for " # NAME " when it shouldn't be."); \
  }
 
typedef struct lexer_state {
  int content_len;
  int line_number;
  int current_line;
  int start_col;
  size_t mark;
  size_t keyword_start;
  size_t keyword_end;
  size_t next_keyword_start;
  size_t content_start;
  size_t content_end;
  size_t docstring_content_type_start;
  size_t docstring_content_type_end;
  size_t query_start;
  size_t last_newline;
  size_t final_newline;
} lexer_state;

static VALUE mGherkin;
static VALUE mGherkinLexer;
static VALUE mCLexer;
static VALUE cI18nLexer;
static VALUE rb_eGherkinLexingError;

#define LEN(AT, P) (P - data - lexer->AT)
#define MARK(M, P) (lexer->M = (P) - data)
#define PTR_TO(P) (data + lexer->P)

#define STORE_KW_END_CON(EVENT) \
  store_multiline_kw_con(listener, # EVENT, \
    PTR_TO(keyword_start), LEN(keyword_start, PTR_TO(keyword_end - 1)), \
    PTR_TO(content_start), LEN(content_start, PTR_TO(content_end)), \
    lexer->current_line, lexer->start_col); \
    if (lexer->content_end != 0) { \
      p = PTR_TO(content_end - 1); \
    } \
    lexer->content_end = 0

#define STORE_ATTR(ATTR) \
    store_attr(listener, # ATTR, \
      PTR_TO(content_start), LEN(content_start, p), \
      lexer->line_number)


#line 254 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"


/** Data **/

#line 89 "ext/gherkin_lexer_bm/gherkin_lexer_bm.c"
static const char _lexer_actions[] = {
	0, 1, 0, 1, 1, 1, 2, 1, 
	3, 1, 4, 1, 5, 1, 6, 1, 
	7, 1, 8, 1, 9, 1, 10, 1, 
	11, 1, 12, 1, 13, 1, 16, 1, 
	17, 1, 18, 1, 19, 1, 20, 1, 
	21, 1, 22, 1, 23, 2, 1, 18, 
	2, 4, 5, 2, 13, 0, 2, 14, 
	15, 2, 17, 0, 2, 17, 2, 2, 
	17, 16, 2, 17, 19, 2, 18, 6, 
	2, 18, 7, 2, 18, 8, 2, 18, 
	9, 2, 18, 10, 2, 18, 16, 2, 
	20, 21, 2, 22, 0, 2, 22, 2, 
	2, 22, 16, 2, 22, 19, 3, 3, 
	14, 15, 3, 5, 14, 15, 3, 11, 
	14, 15, 3, 12, 14, 15, 3, 13, 
	14, 15, 3, 14, 15, 18, 3, 17, 
	0, 11, 3, 17, 14, 15, 4, 1, 
	14, 15, 18, 4, 4, 5, 14, 15, 
	4, 17, 0, 14, 15, 5, 17, 0, 
	11, 14, 15
};

static const short _lexer_key_offsets[] = {
	0, 0, 21, 22, 23, 43, 44, 45, 
	47, 49, 54, 59, 64, 69, 73, 77, 
	79, 80, 81, 82, 83, 84, 85, 86, 
	87, 88, 89, 90, 91, 92, 93, 94, 
	95, 97, 99, 104, 111, 116, 117, 118, 
	119, 120, 121, 122, 123, 124, 125, 126, 
	127, 128, 129, 130, 131, 132, 133, 140, 
	142, 144, 146, 148, 150, 152, 172, 173, 
	174, 175, 176, 177, 178, 179, 180, 181, 
	182, 194, 196, 198, 200, 202, 204, 206, 
	208, 210, 212, 214, 216, 218, 220, 222, 
	224, 226, 228, 230, 232, 234, 236, 238, 
	240, 242, 244, 246, 248, 250, 252, 254, 
	256, 258, 260, 262, 264, 266, 268, 270, 
	272, 274, 276, 278, 280, 282, 284, 286, 
	288, 290, 292, 294, 296, 298, 300, 302, 
	304, 306, 308, 309, 310, 311, 312, 313, 
	314, 315, 316, 317, 318, 319, 320, 321, 
	322, 323, 324, 325, 326, 327, 328, 329, 
	345, 347, 349, 351, 353, 355, 357, 359, 
	361, 363, 365, 367, 369, 371, 373, 375, 
	377, 379, 381, 383, 385, 387, 389, 391, 
	393, 395, 397, 399, 401, 403, 405, 407, 
	409, 411, 413, 415, 417, 419, 421, 423, 
	425, 427, 429, 431, 433, 435, 437, 439, 
	441, 443, 445, 447, 449, 451, 453, 455, 
	457, 459, 461, 463, 465, 466, 467, 468, 
	469, 470, 471, 472, 473, 474, 475, 476, 
	477, 478, 479, 480, 481, 482, 483, 484, 
	485, 486, 487, 502, 504, 506, 508, 510, 
	512, 514, 516, 518, 520, 522, 524, 526, 
	528, 530, 532, 534, 536, 538, 540, 542, 
	544, 546, 548, 550, 552, 554, 556, 558, 
	560, 562, 564, 566, 568, 570, 572, 574, 
	576, 578, 580, 582, 584, 586, 588, 590, 
	592, 594, 596, 597, 598, 599, 600, 601, 
	602, 603, 604, 605, 622, 624, 626, 628, 
	630, 632, 634, 636, 638, 640, 642, 644, 
	646, 648, 650, 652, 654, 656, 658, 660, 
	662, 664, 666, 668, 670, 672, 674, 676, 
	678, 680, 682, 684, 686, 688, 690, 692, 
	694, 696, 698, 700, 702, 704, 706, 708, 
	710, 712, 714, 716, 718, 720, 722, 724, 
	726, 728, 730, 732, 734, 736, 738, 740, 
	742, 744, 746, 748, 750, 752, 754, 756, 
	758, 760, 762, 764, 766, 768, 769, 770, 
	771, 772, 776, 782, 785, 787, 793, 813
};

static const char _lexer_trans_keys[] = {
	-17, 10, 32, 34, 35, 37, 42, 64, 
	65, 66, 67, 68, 70, 75, 76, 77, 
	83, 84, 124, 9, 13, -69, -65, 10, 
	32, 34, 35, 37, 42, 64, 65, 66, 
	67, 68, 70, 75, 76, 77, 83, 84, 
	124, 9, 13, 34, 34, 10, 13, 10, 
	13, 10, 32, 34, 9, 13, 10, 32, 
	34, 9, 13, 10, 32, 34, 9, 13, 
	10, 32, 34, 9, 13, 10, 32, 9, 
	13, 10, 32, 9, 13, 10, 13, 10, 
	95, 70, 69, 65, 84, 85, 82, 69, 
	95, 69, 78, 68, 95, 37, 32, 10, 
	13, 10, 13, 13, 32, 64, 9, 10, 
	9, 10, 13, 32, 64, 11, 12, 10, 
	32, 64, 9, 13, 112, 97, 98, 105, 
	108, 97, 97, 103, 105, 111, 110, 116, 
	111, 104, 58, 10, 10, 10, 32, 35, 
	70, 124, 9, 13, 10, 117, 10, 110, 
	10, 103, 10, 115, 10, 105, 10, 58, 
	10, 32, 34, 35, 37, 42, 64, 65, 
	66, 67, 68, 70, 75, 76, 77, 83, 
	84, 124, 9, 13, 97, 110, 117, 110, 
	103, 115, 105, 58, 10, 10, 10, 32, 
	35, 37, 64, 67, 70, 76, 77, 83, 
	9, 13, 10, 95, 10, 70, 10, 69, 
	10, 65, 10, 84, 10, 85, 10, 82, 
	10, 69, 10, 95, 10, 69, 10, 78, 
	10, 68, 10, 95, 10, 37, 10, 111, 
	10, 110, 10, 116, 10, 111, 10, 104, 
	10, 58, 10, 117, 10, 110, 10, 103, 
	10, 115, 10, 105, 10, 97, 10, 116, 
	10, 97, 10, 114, 10, 32, 10, 66, 
	10, 101, 10, 108, 10, 97, 10, 107, 
	10, 97, 10, 110, 10, 103, 10, 101, 
	10, 110, 10, 103, 10, 103, 10, 97, 
	10, 114, 10, 105, 10, 115, 10, 107, 
	10, 97, 10, 110, 10, 32, 10, 83, 
	10, 101, 10, 110, 10, 97, 10, 114, 
	10, 105, 10, 111, 101, 109, 117, 100, 
	105, 97, 116, 97, 114, 32, 66, 101, 
	108, 97, 107, 97, 110, 103, 58, 10, 
	10, 10, 32, 35, 37, 42, 64, 65, 
	66, 68, 70, 75, 77, 83, 84, 9, 
	13, 10, 95, 10, 70, 10, 69, 10, 
	65, 10, 84, 10, 85, 10, 82, 10, 
	69, 10, 95, 10, 69, 10, 78, 10, 
	68, 10, 95, 10, 37, 10, 32, 10, 
	112, 10, 97, 10, 98, 10, 105, 10, 
	108, 10, 97, 10, 97, 10, 103, 10, 
	105, 10, 97, 10, 110, 10, 117, 10, 
	110, 10, 103, 10, 115, 10, 105, 10, 
	58, 10, 101, 10, 109, 10, 117, 10, 
	100, 10, 105, 10, 101, 10, 110, 10, 
	103, 10, 103, 10, 97, 10, 114, 10, 
	105, 10, 115, 10, 107, 10, 97, 10, 
	110, 10, 32, 10, 83, 10, 101, 10, 
	110, 10, 97, 10, 114, 10, 105, 10, 
	111, 10, 101, 10, 116, 10, 97, 10, 
	112, 101, 110, 103, 103, 97, 114, 105, 
	115, 107, 97, 110, 32, 83, 101, 110, 
	97, 114, 105, 111, 58, 10, 10, 10, 
	32, 35, 37, 42, 64, 65, 66, 68, 
	70, 75, 83, 84, 9, 13, 10, 95, 
	10, 70, 10, 69, 10, 65, 10, 84, 
	10, 85, 10, 82, 10, 69, 10, 95, 
	10, 69, 10, 78, 10, 68, 10, 95, 
	10, 37, 10, 32, 10, 112, 10, 97, 
	10, 98, 10, 105, 10, 108, 10, 97, 
	10, 97, 10, 103, 10, 105, 10, 97, 
	10, 110, 10, 117, 10, 110, 10, 103, 
	10, 115, 10, 105, 10, 58, 10, 101, 
	10, 109, 10, 117, 10, 100, 10, 105, 
	10, 101, 10, 110, 10, 97, 10, 114, 
	10, 105, 10, 111, 10, 101, 10, 116, 
	10, 97, 10, 112, 101, 110, 97, 114, 
	105, 111, 58, 10, 10, 10, 32, 35, 
	37, 42, 64, 65, 66, 68, 70, 75, 
	76, 77, 83, 84, 9, 13, 10, 95, 
	10, 70, 10, 69, 10, 65, 10, 84, 
	10, 85, 10, 82, 10, 69, 10, 95, 
	10, 69, 10, 78, 10, 68, 10, 95, 
	10, 37, 10, 32, 10, 112, 10, 97, 
	10, 98, 10, 105, 10, 108, 10, 97, 
	10, 97, 10, 103, 10, 105, 10, 97, 
	10, 110, 10, 117, 10, 110, 10, 103, 
	10, 115, 10, 105, 10, 58, 10, 101, 
	10, 109, 10, 117, 10, 100, 10, 105, 
	10, 97, 10, 116, 10, 97, 10, 114, 
	10, 32, 10, 66, 10, 101, 10, 108, 
	10, 97, 10, 107, 10, 97, 10, 110, 
	10, 103, 10, 101, 10, 110, 10, 103, 
	10, 103, 10, 97, 10, 114, 10, 105, 
	10, 115, 10, 107, 10, 97, 10, 110, 
	10, 32, 10, 83, 10, 101, 10, 110, 
	10, 97, 10, 114, 10, 105, 10, 111, 
	10, 101, 10, 116, 10, 97, 10, 112, 
	101, 116, 97, 112, 32, 124, 9, 13, 
	10, 32, 92, 124, 9, 13, 10, 92, 
	124, 10, 92, 10, 32, 92, 124, 9, 
	13, 10, 32, 34, 35, 37, 42, 64, 
	65, 66, 67, 68, 70, 75, 76, 77, 
	83, 84, 124, 9, 13, 0
};

static const char _lexer_single_lengths[] = {
	0, 19, 1, 1, 18, 1, 1, 2, 
	2, 3, 3, 3, 3, 2, 2, 2, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	2, 2, 3, 5, 3, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 5, 2, 
	2, 2, 2, 2, 2, 18, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	10, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 14, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 13, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 15, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 1, 1, 1, 
	1, 2, 4, 3, 2, 4, 18, 0
};

static const char _lexer_range_lengths[] = {
	0, 1, 0, 0, 1, 0, 0, 0, 
	0, 1, 1, 1, 1, 1, 1, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 1, 1, 1, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 1, 0, 
	0, 0, 0, 0, 0, 1, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	1, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 1, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 1, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 1, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 1, 1, 0, 0, 1, 1, 0
};

static const short _lexer_index_offsets[] = {
	0, 0, 21, 23, 25, 45, 47, 49, 
	52, 55, 60, 65, 70, 75, 79, 83, 
	86, 88, 90, 92, 94, 96, 98, 100, 
	102, 104, 106, 108, 110, 112, 114, 116, 
	118, 121, 124, 129, 136, 141, 143, 145, 
	147, 149, 151, 153, 155, 157, 159, 161, 
	163, 165, 167, 169, 171, 173, 175, 182, 
	185, 188, 191, 194, 197, 200, 220, 222, 
	224, 226, 228, 230, 232, 234, 236, 238, 
	240, 252, 255, 258, 261, 264, 267, 270, 
	273, 276, 279, 282, 285, 288, 291, 294, 
	297, 300, 303, 306, 309, 312, 315, 318, 
	321, 324, 327, 330, 333, 336, 339, 342, 
	345, 348, 351, 354, 357, 360, 363, 366, 
	369, 372, 375, 378, 381, 384, 387, 390, 
	393, 396, 399, 402, 405, 408, 411, 414, 
	417, 420, 423, 425, 427, 429, 431, 433, 
	435, 437, 439, 441, 443, 445, 447, 449, 
	451, 453, 455, 457, 459, 461, 463, 465, 
	481, 484, 487, 490, 493, 496, 499, 502, 
	505, 508, 511, 514, 517, 520, 523, 526, 
	529, 532, 535, 538, 541, 544, 547, 550, 
	553, 556, 559, 562, 565, 568, 571, 574, 
	577, 580, 583, 586, 589, 592, 595, 598, 
	601, 604, 607, 610, 613, 616, 619, 622, 
	625, 628, 631, 634, 637, 640, 643, 646, 
	649, 652, 655, 658, 661, 663, 665, 667, 
	669, 671, 673, 675, 677, 679, 681, 683, 
	685, 687, 689, 691, 693, 695, 697, 699, 
	701, 703, 705, 720, 723, 726, 729, 732, 
	735, 738, 741, 744, 747, 750, 753, 756, 
	759, 762, 765, 768, 771, 774, 777, 780, 
	783, 786, 789, 792, 795, 798, 801, 804, 
	807, 810, 813, 816, 819, 822, 825, 828, 
	831, 834, 837, 840, 843, 846, 849, 852, 
	855, 858, 861, 863, 865, 867, 869, 871, 
	873, 875, 877, 879, 896, 899, 902, 905, 
	908, 911, 914, 917, 920, 923, 926, 929, 
	932, 935, 938, 941, 944, 947, 950, 953, 
	956, 959, 962, 965, 968, 971, 974, 977, 
	980, 983, 986, 989, 992, 995, 998, 1001, 
	1004, 1007, 1010, 1013, 1016, 1019, 1022, 1025, 
	1028, 1031, 1034, 1037, 1040, 1043, 1046, 1049, 
	1052, 1055, 1058, 1061, 1064, 1067, 1070, 1073, 
	1076, 1079, 1082, 1085, 1088, 1091, 1094, 1097, 
	1100, 1103, 1106, 1109, 1112, 1115, 1117, 1119, 
	1121, 1123, 1127, 1133, 1137, 1140, 1146, 1166
};

static const short _lexer_trans_targs[] = {
	2, 4, 4, 5, 15, 17, 31, 34, 
	37, 43, 46, 62, 64, 130, 135, 212, 
	282, 365, 369, 4, 0, 3, 0, 4, 
	0, 4, 4, 5, 15, 17, 31, 34, 
	37, 43, 46, 62, 64, 130, 135, 212, 
	282, 365, 369, 4, 0, 6, 0, 7, 
	0, 9, 8, 8, 9, 8, 8, 10, 
	10, 11, 10, 10, 10, 10, 11, 10, 
	10, 10, 10, 12, 10, 10, 10, 10, 
	13, 10, 10, 4, 14, 14, 0, 4, 
	14, 14, 0, 4, 16, 15, 4, 0, 
	18, 0, 19, 0, 20, 0, 21, 0, 
	22, 0, 23, 0, 24, 0, 25, 0, 
	26, 0, 27, 0, 28, 0, 29, 0, 
	30, 0, 375, 0, 32, 0, 4, 16, 
	33, 4, 16, 33, 0, 0, 0, 0, 
	35, 36, 4, 36, 36, 34, 35, 35, 
	4, 36, 34, 36, 0, 38, 0, 39, 
	0, 40, 0, 41, 0, 42, 0, 31, 
	0, 44, 0, 45, 0, 31, 0, 47, 
	0, 48, 0, 49, 0, 50, 0, 51, 
	0, 52, 0, 54, 53, 54, 53, 54, 
	54, 4, 55, 4, 54, 53, 54, 56, 
	53, 54, 57, 53, 54, 58, 53, 54, 
	59, 53, 54, 60, 53, 54, 61, 53, 
	4, 4, 5, 15, 17, 31, 34, 37, 
	43, 46, 62, 64, 130, 135, 212, 282, 
	365, 369, 4, 0, 63, 0, 31, 0, 
	65, 0, 66, 0, 67, 0, 68, 0, 
	69, 0, 70, 0, 72, 71, 72, 71, 
	72, 72, 4, 73, 4, 87, 93, 98, 
	111, 124, 72, 71, 72, 74, 71, 72, 
	75, 71, 72, 76, 71, 72, 77, 71, 
	72, 78, 71, 72, 79, 71, 72, 80, 
	71, 72, 81, 71, 72, 82, 71, 72, 
	83, 71, 72, 84, 71, 72, 85, 71, 
	72, 86, 71, 72, 4, 71, 72, 88, 
	71, 72, 89, 71, 72, 90, 71, 72, 
	91, 71, 72, 92, 71, 72, 61, 71, 
	72, 94, 71, 72, 95, 71, 72, 96, 
	71, 72, 97, 71, 72, 92, 71, 72, 
	99, 71, 72, 100, 71, 72, 101, 71, 
	72, 102, 71, 72, 103, 71, 72, 104, 
	71, 72, 105, 71, 72, 106, 71, 72, 
	107, 71, 72, 108, 71, 72, 109, 71, 
	72, 110, 71, 72, 92, 71, 72, 112, 
	71, 72, 113, 71, 72, 114, 71, 72, 
	115, 71, 72, 116, 71, 72, 117, 71, 
	72, 118, 71, 72, 119, 71, 72, 120, 
	71, 72, 121, 71, 72, 122, 71, 72, 
	123, 71, 72, 124, 71, 72, 125, 71, 
	72, 126, 71, 72, 127, 71, 72, 128, 
	71, 72, 129, 71, 72, 92, 71, 131, 
	0, 132, 0, 133, 0, 134, 0, 62, 
	0, 136, 0, 137, 0, 138, 0, 139, 
	0, 140, 0, 141, 0, 142, 0, 143, 
	0, 144, 0, 145, 0, 146, 0, 147, 
	0, 148, 0, 149, 0, 151, 150, 151, 
	150, 151, 151, 4, 152, 166, 4, 167, 
	173, 176, 178, 184, 189, 202, 208, 151, 
	150, 151, 153, 150, 151, 154, 150, 151, 
	155, 150, 151, 156, 150, 151, 157, 150, 
	151, 158, 150, 151, 159, 150, 151, 160, 
	150, 151, 161, 150, 151, 162, 150, 151, 
	163, 150, 151, 164, 150, 151, 165, 150, 
	151, 4, 150, 151, 61, 150, 151, 168, 
	150, 151, 169, 150, 151, 170, 150, 151, 
	171, 150, 151, 172, 150, 151, 166, 150, 
	151, 174, 150, 151, 175, 150, 151, 166, 
	150, 151, 177, 150, 151, 166, 150, 151, 
	179, 150, 151, 180, 150, 151, 181, 150, 
	151, 182, 150, 151, 183, 150, 151, 61, 
	150, 151, 185, 150, 151, 186, 150, 151, 
	187, 150, 151, 188, 150, 151, 176, 150, 
	151, 190, 150, 151, 191, 150, 151, 192, 
	150, 151, 193, 150, 151, 194, 150, 151, 
	195, 150, 151, 196, 150, 151, 197, 150, 
	151, 198, 150, 151, 199, 150, 151, 200, 
	150, 151, 201, 150, 151, 202, 150, 151, 
	203, 150, 151, 204, 150, 151, 205, 150, 
	151, 206, 150, 151, 207, 150, 151, 183, 
	150, 151, 209, 150, 151, 210, 150, 151, 
	211, 150, 151, 175, 150, 213, 0, 214, 
	0, 215, 0, 216, 0, 217, 0, 218, 
	0, 219, 0, 220, 0, 221, 0, 222, 
	0, 223, 0, 224, 0, 225, 0, 226, 
	0, 227, 0, 228, 0, 229, 0, 230, 
	0, 231, 0, 232, 0, 234, 233, 234, 
	233, 234, 234, 4, 235, 249, 4, 250, 
	256, 259, 261, 267, 272, 278, 234, 233, 
	234, 236, 233, 234, 237, 233, 234, 238, 
	233, 234, 239, 233, 234, 240, 233, 234, 
	241, 233, 234, 242, 233, 234, 243, 233, 
	234, 244, 233, 234, 245, 233, 234, 246, 
	233, 234, 247, 233, 234, 248, 233, 234, 
	4, 233, 234, 61, 233, 234, 251, 233, 
	234, 252, 233, 234, 253, 233, 234, 254, 
	233, 234, 255, 233, 234, 249, 233, 234, 
	257, 233, 234, 258, 233, 234, 249, 233, 
	234, 260, 233, 234, 249, 233, 234, 262, 
	233, 234, 263, 233, 234, 264, 233, 234, 
	265, 233, 234, 266, 233, 234, 61, 233, 
	234, 268, 233, 234, 269, 233, 234, 270, 
	233, 234, 271, 233, 234, 259, 233, 234, 
	273, 233, 234, 274, 233, 234, 275, 233, 
	234, 276, 233, 234, 277, 233, 234, 266, 
	233, 234, 279, 233, 234, 280, 233, 234, 
	281, 233, 234, 258, 233, 283, 0, 284, 
	0, 285, 0, 286, 0, 287, 0, 288, 
	0, 289, 0, 291, 290, 291, 290, 291, 
	291, 4, 292, 306, 4, 307, 313, 316, 
	318, 324, 329, 342, 355, 361, 291, 290, 
	291, 293, 290, 291, 294, 290, 291, 295, 
	290, 291, 296, 290, 291, 297, 290, 291, 
	298, 290, 291, 299, 290, 291, 300, 290, 
	291, 301, 290, 291, 302, 290, 291, 303, 
	290, 291, 304, 290, 291, 305, 290, 291, 
	4, 290, 291, 61, 290, 291, 308, 290, 
	291, 309, 290, 291, 310, 290, 291, 311, 
	290, 291, 312, 290, 291, 306, 290, 291, 
	314, 290, 291, 315, 290, 291, 306, 290, 
	291, 317, 290, 291, 306, 290, 291, 319, 
	290, 291, 320, 290, 291, 321, 290, 291, 
	322, 290, 291, 323, 290, 291, 61, 290, 
	291, 325, 290, 291, 326, 290, 291, 327, 
	290, 291, 328, 290, 291, 316, 290, 291, 
	330, 290, 291, 331, 290, 291, 332, 290, 
	291, 333, 290, 291, 334, 290, 291, 335, 
	290, 291, 336, 290, 291, 337, 290, 291, 
	338, 290, 291, 339, 290, 291, 340, 290, 
	291, 341, 290, 291, 323, 290, 291, 343, 
	290, 291, 344, 290, 291, 345, 290, 291, 
	346, 290, 291, 347, 290, 291, 348, 290, 
	291, 349, 290, 291, 350, 290, 291, 351, 
	290, 291, 352, 290, 291, 353, 290, 291, 
	354, 290, 291, 355, 290, 291, 356, 290, 
	291, 357, 290, 291, 358, 290, 291, 359, 
	290, 291, 360, 290, 291, 323, 290, 291, 
	362, 290, 291, 363, 290, 291, 364, 290, 
	291, 315, 290, 366, 0, 367, 0, 368, 
	0, 45, 0, 369, 370, 369, 0, 374, 
	373, 372, 370, 373, 371, 0, 372, 370, 
	371, 0, 372, 371, 374, 373, 372, 370, 
	373, 371, 374, 374, 5, 15, 17, 31, 
	34, 37, 43, 46, 62, 64, 130, 135, 
	212, 282, 365, 369, 374, 0, 0, 0
};

static const unsigned char _lexer_trans_actions[] = {
	0, 54, 0, 5, 1, 0, 29, 1, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 35, 0, 43, 0, 43, 0, 
	43, 54, 0, 5, 1, 0, 29, 1, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 35, 0, 43, 0, 43, 0, 
	43, 139, 48, 9, 106, 11, 0, 134, 
	45, 45, 45, 3, 122, 33, 33, 33, 
	0, 122, 33, 33, 33, 0, 122, 33, 
	0, 33, 0, 102, 7, 7, 43, 54, 
	0, 0, 43, 114, 25, 0, 54, 43, 
	0, 43, 0, 43, 0, 43, 0, 43, 
	0, 43, 0, 43, 0, 43, 0, 43, 
	0, 43, 0, 43, 0, 43, 0, 43, 
	0, 43, 0, 43, 0, 43, 149, 126, 
	57, 110, 23, 0, 43, 43, 43, 43, 
	0, 27, 118, 27, 27, 51, 27, 0, 
	54, 0, 1, 0, 43, 0, 43, 0, 
	43, 0, 43, 0, 43, 0, 43, 0, 
	43, 0, 43, 0, 43, 0, 43, 0, 
	43, 0, 43, 0, 43, 0, 43, 0, 
	43, 0, 43, 144, 57, 54, 0, 54, 
	0, 81, 84, 81, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 21, 0, 
	130, 31, 60, 57, 31, 63, 57, 63, 
	63, 63, 63, 63, 63, 63, 63, 63, 
	63, 66, 31, 43, 0, 43, 0, 43, 
	0, 43, 0, 43, 0, 43, 0, 43, 
	0, 43, 0, 43, 144, 57, 54, 0, 
	54, 0, 69, 33, 69, 84, 84, 84, 
	84, 84, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 0, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 0, 0, 
	54, 0, 0, 54, 13, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 13, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 0, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 0, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 0, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 0, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 0, 
	43, 0, 43, 0, 43, 0, 43, 0, 
	43, 0, 43, 0, 43, 0, 43, 0, 
	43, 0, 43, 0, 43, 0, 43, 0, 
	43, 0, 43, 0, 43, 0, 43, 0, 
	43, 0, 43, 0, 43, 144, 57, 54, 
	0, 54, 0, 72, 33, 84, 72, 84, 
	84, 84, 84, 84, 84, 84, 84, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 0, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 0, 0, 
	54, 15, 0, 54, 15, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 0, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 0, 0, 
	54, 0, 0, 54, 0, 0, 54, 15, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 0, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 0, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 0, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 0, 43, 0, 
	43, 0, 43, 0, 43, 0, 43, 0, 
	43, 0, 43, 0, 43, 0, 43, 0, 
	43, 0, 43, 0, 43, 0, 43, 0, 
	43, 0, 43, 0, 43, 0, 43, 0, 
	43, 0, 43, 0, 43, 144, 57, 54, 
	0, 54, 0, 78, 33, 84, 78, 84, 
	84, 84, 84, 84, 84, 84, 0, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 0, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	19, 0, 54, 19, 0, 54, 0, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 0, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 19, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 0, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 0, 43, 0, 
	43, 0, 43, 0, 43, 0, 43, 0, 
	43, 0, 43, 144, 57, 54, 0, 54, 
	0, 75, 33, 84, 75, 84, 84, 84, 
	84, 84, 84, 84, 84, 84, 0, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 0, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	17, 0, 54, 17, 0, 54, 0, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 0, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 17, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 0, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 0, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 0, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 0, 0, 
	54, 0, 0, 54, 0, 0, 54, 0, 
	0, 54, 0, 0, 54, 0, 0, 54, 
	0, 0, 54, 0, 0, 54, 0, 0, 
	54, 0, 0, 0, 43, 0, 43, 0, 
	43, 0, 43, 0, 0, 0, 43, 54, 
	37, 37, 87, 37, 37, 43, 0, 39, 
	0, 43, 0, 0, 54, 0, 0, 39, 
	0, 0, 54, 0, 93, 90, 41, 96, 
	90, 96, 96, 96, 96, 96, 96, 96, 
	96, 96, 96, 99, 0, 43, 0, 0
};

static const unsigned char _lexer_eof_actions[] = {
	0, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43
};

static const int lexer_start = 1;
static const int lexer_first_final = 375;
static const int lexer_error = 0;

static const int lexer_en_main = 1;


#line 258 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"

static VALUE 
unindent(VALUE con, int start_col)
{
  VALUE re;
  // Gherkin will crash gracefully if the string representation of start_col pushes the pattern past 32 characters
  char pat[32]; 
  snprintf(pat, 32, "^[\t ]{0,%d}", start_col); 
  re = rb_reg_regcomp(rb_str_new2(pat));
  rb_funcall(con, rb_intern("gsub!"), 2, re, rb_str_new2(""));

  return Qnil;

}

static void 
store_kw_con(VALUE listener, const char * event_name, 
             const char * keyword_at, size_t keyword_length, 
             const char * at,         size_t length, 
             int current_line)
{
  VALUE con = Qnil, kw = Qnil;
  kw = ENCODED_STR_NEW(keyword_at, keyword_length);
  con = ENCODED_STR_NEW(at, length);
  rb_funcall(con, rb_intern("strip!"), 0);
  rb_funcall(listener, rb_intern(event_name), 3, kw, con, INT2FIX(current_line)); 
}

static void
store_multiline_kw_con(VALUE listener, const char * event_name,
                      const char * keyword_at, size_t keyword_length,
                      const char * at,         size_t length,
                      int current_line, int start_col)
{
  VALUE split;
  VALUE con = Qnil, kw = Qnil, name = Qnil, desc = Qnil;

  kw = ENCODED_STR_NEW(keyword_at, keyword_length);
  con = ENCODED_STR_NEW(at, length);

  unindent(con, start_col);
  
  split = rb_str_split(con, "\n");

  name = rb_funcall(split, rb_intern("shift"), 0);
  desc = rb_ary_join(split, rb_str_new2( "\n" ));

  if( name == Qnil ) 
  {
    name = rb_str_new2("");
  }
  if( rb_funcall(desc, rb_intern("size"), 0) == 0) 
  {
    desc = rb_str_new2("");
  }
  rb_funcall(name, rb_intern("strip!"), 0);
  rb_funcall(desc, rb_intern("rstrip!"), 0);
  rb_funcall(listener, rb_intern(event_name), 4, kw, name, desc, INT2FIX(current_line)); 
}

static void 
store_attr(VALUE listener, const char * attr_type,
           const char * at, size_t length, 
           int line)
{
  VALUE val = ENCODED_STR_NEW(at, length);
  rb_funcall(listener, rb_intern(attr_type), 2, val, INT2FIX(line));
}
static void 
store_docstring_content(VALUE listener, 
          int start_col, 
          const char *type_at, size_t type_length,
          const char *at, size_t length, 
          int current_line)
{
  VALUE re2;
  VALUE unescape_escaped_quotes;
  VALUE con = ENCODED_STR_NEW(at, length);
  VALUE con_type = ENCODED_STR_NEW(type_at, type_length);

  unindent(con, start_col);

  re2 = rb_reg_regcomp(rb_str_new2("\r\\Z"));
  unescape_escaped_quotes = rb_reg_regcomp(rb_str_new2("\\\\\"\\\\\"\\\\\""));
  rb_funcall(con, rb_intern("sub!"), 2, re2, rb_str_new2(""));
  rb_funcall(con_type, rb_intern("strip!"), 0);
  rb_funcall(con, rb_intern("gsub!"), 2, unescape_escaped_quotes, rb_str_new2("\"\"\""));
  rb_funcall(listener, rb_intern("doc_string"), 3, con_type, con, INT2FIX(current_line));
}
static void 
raise_lexer_error(const char * at, int line)
{ 
  rb_raise(rb_eGherkinLexingError, "Lexing error on line %d: '%s'. See http://wiki.github.com/cucumber/gherkin/lexingerror for more information.", line, at);
}

static void lexer_init(lexer_state *lexer) {
  lexer->content_start = 0;
  lexer->content_end = 0;
  lexer->content_len = 0;
  lexer->docstring_content_type_start = 0;
  lexer->docstring_content_type_end = 0;
  lexer->mark = 0;
  lexer->keyword_start = 0;
  lexer->keyword_end = 0;
  lexer->next_keyword_start = 0;
  lexer->line_number = 1;
  lexer->last_newline = 0;
  lexer->final_newline = 0;
  lexer->start_col = 0;
}

static VALUE CLexer_alloc(VALUE klass)
{
  VALUE obj;
  lexer_state *lxr = ALLOC(lexer_state);
  lexer_init(lxr);

  obj = Data_Wrap_Struct(klass, NULL, -1, lxr);

  return obj;
}

static VALUE CLexer_init(VALUE self, VALUE listener)
{
  lexer_state *lxr; 
  rb_iv_set(self, "@listener", listener);
  
  lxr = NULL;
  DATA_GET(self, lexer_state, lxr);
  lexer_init(lxr);
  
  return self;
}

static VALUE CLexer_scan(VALUE self, VALUE input)
{
  VALUE input_copy;
  char *data;
  size_t len;
  VALUE listener = rb_iv_get(self, "@listener");

  lexer_state *lexer;
  lexer = NULL;
  DATA_GET(self, lexer_state, lexer);

  input_copy = rb_str_dup(input);

  rb_str_append(input_copy, rb_str_new2("\n%_FEATURE_END_%"));
  data = RSTRING_PTR(input_copy);
  len = RSTRING_LEN(input_copy);
  
  if (len == 0) { 
    rb_raise(rb_eGherkinLexingError, "No content to lex.");
  } else {

    const char *p, *pe, *eof;
    int cs = 0;
    
    VALUE current_row = Qnil;

    p = data;
    pe = data + len;
    eof = pe;
    
    assert(*pe == '\0' && "pointer does not end on NULL");
    
    
#line 941 "ext/gherkin_lexer_bm/gherkin_lexer_bm.c"
	{
	cs = lexer_start;
	}

#line 425 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
    
#line 948 "ext/gherkin_lexer_bm/gherkin_lexer_bm.c"
	{
	int _klen;
	unsigned int _trans;
	const char *_acts;
	unsigned int _nacts;
	const char *_keys;

	if ( p == pe )
		goto _test_eof;
	if ( cs == 0 )
		goto _out;
_resume:
	_keys = _lexer_trans_keys + _lexer_key_offsets[cs];
	_trans = _lexer_index_offsets[cs];

	_klen = _lexer_single_lengths[cs];
	if ( _klen > 0 ) {
		const char *_lower = _keys;
		const char *_mid;
		const char *_upper = _keys + _klen - 1;
		while (1) {
			if ( _upper < _lower )
				break;

			_mid = _lower + ((_upper-_lower) >> 1);
			if ( (*p) < *_mid )
				_upper = _mid - 1;
			else if ( (*p) > *_mid )
				_lower = _mid + 1;
			else {
				_trans += (_mid - _keys);
				goto _match;
			}
		}
		_keys += _klen;
		_trans += _klen;
	}

	_klen = _lexer_range_lengths[cs];
	if ( _klen > 0 ) {
		const char *_lower = _keys;
		const char *_mid;
		const char *_upper = _keys + (_klen<<1) - 2;
		while (1) {
			if ( _upper < _lower )
				break;

			_mid = _lower + (((_upper-_lower) >> 1) & ~1);
			if ( (*p) < _mid[0] )
				_upper = _mid - 2;
			else if ( (*p) > _mid[1] )
				_lower = _mid + 2;
			else {
				_trans += ((_mid - _keys)>>1);
				goto _match;
			}
		}
		_trans += _klen;
	}

_match:
	cs = _lexer_trans_targs[_trans];

	if ( _lexer_trans_actions[_trans] == 0 )
		goto _again;

	_acts = _lexer_actions + _lexer_trans_actions[_trans];
	_nacts = (unsigned int) *_acts++;
	while ( _nacts-- > 0 )
	{
		switch ( *_acts++ )
		{
	case 0:
#line 83 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{
		MARK(content_start, p);
    lexer->current_line = lexer->line_number;
    lexer->start_col = lexer->content_start - lexer->last_newline - (lexer->keyword_end - lexer->keyword_start) + 2;
  }
	break;
	case 1:
#line 89 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{
    MARK(content_start, p);
  }
	break;
	case 2:
#line 93 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{
    lexer->current_line = lexer->line_number;
    lexer->start_col = p - data - lexer->last_newline;
  }
	break;
	case 3:
#line 98 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{
    int len = LEN(content_start, PTR_TO(final_newline));
    int type_len = LEN(docstring_content_type_start, PTR_TO(docstring_content_type_end));

    if (len < 0) len = 0;
    if (type_len < 0) len = 0;

    store_docstring_content(listener, lexer->start_col, PTR_TO(docstring_content_type_start), type_len, PTR_TO(content_start), len, lexer->current_line);
  }
	break;
	case 4:
#line 108 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{ 
    MARK(docstring_content_type_start, p);
  }
	break;
	case 5:
#line 112 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{ 
    MARK(docstring_content_type_end, p);
  }
	break;
	case 6:
#line 116 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{
    STORE_KW_END_CON(feature);
  }
	break;
	case 7:
#line 120 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{
    STORE_KW_END_CON(background);
  }
	break;
	case 8:
#line 124 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{
    STORE_KW_END_CON(scenario);
  }
	break;
	case 9:
#line 128 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{
    STORE_KW_END_CON(scenario_outline);
  }
	break;
	case 10:
#line 132 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{
    STORE_KW_END_CON(examples);
  }
	break;
	case 11:
#line 136 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{
    store_kw_con(listener, "step",
      PTR_TO(keyword_start), LEN(keyword_start, PTR_TO(keyword_end)),
      PTR_TO(content_start), LEN(content_start, p), 
      lexer->current_line);
  }
	break;
	case 12:
#line 143 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{
    STORE_ATTR(comment);
    lexer->mark = 0;
  }
	break;
	case 13:
#line 148 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{
    STORE_ATTR(tag);
    lexer->mark = 0;
  }
	break;
	case 14:
#line 153 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{
    lexer->line_number += 1;
    MARK(final_newline, p);
  }
	break;
	case 15:
#line 158 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{
    MARK(last_newline, p + 1);
  }
	break;
	case 16:
#line 162 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{
    if (lexer->mark == 0) {
      MARK(mark, p);
    }
  }
	break;
	case 17:
#line 168 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{
    MARK(keyword_end, p);
    MARK(keyword_start, PTR_TO(mark));
    MARK(content_start, p + 1);
    lexer->mark = 0;
  }
	break;
	case 18:
#line 175 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{
    MARK(content_end, p);
  }
	break;
	case 19:
#line 179 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{
    p = p - 1;
    lexer->current_line = lexer->line_number;
    current_row = rb_ary_new();
  }
	break;
	case 20:
#line 185 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{
		MARK(content_start, p);
  }
	break;
	case 21:
#line 189 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{
    VALUE re_pipe, re_newline, re_backslash;
    VALUE con = ENCODED_STR_NEW(PTR_TO(content_start), LEN(content_start, p));
    rb_funcall(con, rb_intern("strip!"), 0);
    re_pipe      = rb_reg_regcomp(rb_str_new2("\\\\\\|"));
    re_newline   = rb_reg_regcomp(rb_str_new2("\\\\n"));
    re_backslash = rb_reg_regcomp(rb_str_new2("\\\\\\\\"));
    rb_funcall(con, rb_intern("gsub!"), 2, re_pipe,      rb_str_new2("|"));
    rb_funcall(con, rb_intern("gsub!"), 2, re_newline,   rb_str_new2("\n"));
    rb_funcall(con, rb_intern("gsub!"), 2, re_backslash, rb_str_new2("\\"));

    rb_ary_push(current_row, con);
  }
	break;
	case 22:
#line 203 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{
    rb_funcall(listener, rb_intern("row"), 2, current_row, INT2FIX(lexer->current_line));
  }
	break;
	case 23:
#line 207 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{
    int line;
    if (cs < lexer_first_final) {
      size_t count = 0;
      VALUE newstr_val;
      char *newstr;
      int newstr_count = 0;        
      size_t len;
      const char *buff;
      if (lexer->last_newline != 0) {
        len = LEN(last_newline, eof);
        buff = PTR_TO(last_newline);
      } else {
        len = strlen(data);
        buff = data;
      }

      // Allocate as a ruby string so that it gets cleaned up by GC
      newstr_val = rb_str_new(buff, len);
      newstr = RSTRING_PTR(newstr_val);


      for (count = 0; count < len; count++) {
        if(buff[count] == 10) {
          newstr[newstr_count] = '\0'; // terminate new string at first newline found
          break;
        } else {
          if (buff[count] == '%') {
            newstr[newstr_count++] = buff[count];
            newstr[newstr_count] = buff[count];
          } else {
            newstr[newstr_count] = buff[count];
          }
        }
        newstr_count++;
      }

      line = lexer->line_number;
      lexer_init(lexer); // Re-initialize so we can scan again with the same lexer
      raise_lexer_error(newstr, line);
    } else {
      rb_funcall(listener, rb_intern("eof"), 0);
    }
  }
	break;
#line 1238 "ext/gherkin_lexer_bm/gherkin_lexer_bm.c"
		}
	}

_again:
	if ( cs == 0 )
		goto _out;
	if ( ++p != pe )
		goto _resume;
	_test_eof: {}
	if ( p == eof )
	{
	const char *__acts = _lexer_actions + _lexer_eof_actions[cs];
	unsigned int __nacts = (unsigned int) *__acts++;
	while ( __nacts-- > 0 ) {
		switch ( *__acts++ ) {
	case 23:
#line 207 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"
	{
    int line;
    if (cs < lexer_first_final) {
      size_t count = 0;
      VALUE newstr_val;
      char *newstr;
      int newstr_count = 0;        
      size_t len;
      const char *buff;
      if (lexer->last_newline != 0) {
        len = LEN(last_newline, eof);
        buff = PTR_TO(last_newline);
      } else {
        len = strlen(data);
        buff = data;
      }

      // Allocate as a ruby string so that it gets cleaned up by GC
      newstr_val = rb_str_new(buff, len);
      newstr = RSTRING_PTR(newstr_val);


      for (count = 0; count < len; count++) {
        if(buff[count] == 10) {
          newstr[newstr_count] = '\0'; // terminate new string at first newline found
          break;
        } else {
          if (buff[count] == '%') {
            newstr[newstr_count++] = buff[count];
            newstr[newstr_count] = buff[count];
          } else {
            newstr[newstr_count] = buff[count];
          }
        }
        newstr_count++;
      }

      line = lexer->line_number;
      lexer_init(lexer); // Re-initialize so we can scan again with the same lexer
      raise_lexer_error(newstr, line);
    } else {
      rb_funcall(listener, rb_intern("eof"), 0);
    }
  }
	break;
#line 1301 "ext/gherkin_lexer_bm/gherkin_lexer_bm.c"
		}
	}
	}

	_out: {}
	}

#line 426 "/Users/ahellesoy/github/gherkin/tasks/../ragel/i18n/bm.c.rl"

    assert(p <= pe && "data overflow after parsing execute");
    assert(lexer->content_start <= len && "content starts after data end");
    assert(lexer->mark < len && "mark is after data end");
    
    // Reset lexer by re-initializing the whole thing
    lexer_init(lexer);

    if (cs == lexer_error) {
      rb_raise(rb_eGherkinLexingError, "Invalid format, lexing fails.");
    } else {
      return Qtrue;
    }
  }
}

void Init_gherkin_lexer_bm()
{
  mGherkin = rb_define_module("Gherkin");
  mGherkinLexer = rb_define_module_under(mGherkin, "Lexer");
  rb_eGherkinLexingError = rb_const_get(mGherkinLexer, rb_intern("LexingError"));

  mCLexer = rb_define_module_under(mGherkin, "CLexer");
  cI18nLexer = rb_define_class_under(mCLexer, "Bm", rb_cObject);
  rb_define_alloc_func(cI18nLexer, CLexer_alloc);
  rb_define_method(cI18nLexer, "initialize", CLexer_init, 1);
  rb_define_method(cI18nLexer, "scan", CLexer_scan, 1);
}

