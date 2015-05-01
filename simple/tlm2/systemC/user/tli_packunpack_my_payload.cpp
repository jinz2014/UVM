// *********************************************************************
// *              Copyright (c) 2005-2010 Synopsys, Inc.               *
// *                                                                   *
// * This software and the associated documentation are confidential   *
// * and proprietary to Synopsys, Inc. Your use or disclosure of this  *
// * software is subject to the terms and conditions of a written      *
// * license agreement between you, or your company, and Synopsys, Inc.*
// *********************************************************************/

#include "tli_packunpack_my_payload.h"
// pack/unpack routines for public members of class my_payload
void tli_conv2_pack_my_payload(tli_pack_data& P, const my_payload& my_payload_obj)
{
    P << my_payload_obj.data;
    P << my_payload_obj.addr;
    P << my_payload_obj.response;
}
void tli_conv2_unpack_my_payload(tli_pack_data& P, my_payload& my_payload_obj)
{
    P >> my_payload_obj.data;
    P >> my_payload_obj.addr;
    P >> my_payload_obj.response;
}

template <> void  tli_conv2_pack_tlmgp(tli_pack_data& P, my_payload& my_payload_obj)
{
   tli_conv2_pack_my_payload(P, my_payload_obj);
}
template <> void  tli_conv2_unpack_tlmgp(tli_pack_data& P, my_payload& my_payload_obj)
{
   tli_conv2_unpack_my_payload(P, my_payload_obj);
}
