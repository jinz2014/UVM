---------------------------------------------------------------
File name   :  gpio_transfer.e
Created     :  Tue Jun 17 13:52:04 2008
Description :  This file declares the base transfer struct
            :  and also the Interface and the Not_required
            :  items which inherit from the base struct.
Notes       :  
---------------------------------------------------------------
Copyright 1999-2010 Cadence Design Systems, Inc.
All Rights Reserved Worldwide

Licensed under the Apache License, Version 2.0 (the
"License"); you may not use this file except in
compliance with the License.  You may obtain a copy of
the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in
writing, software distributed under the License is
distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied.  See
the License for the specific language governing
permissions and limitations under the License.
---------------------------------------------------------------

<'
package gpio;

-- This type is used to sub-type the transfer struct. By default the transfer
-- is a generic transfer, but other code can extend this type to create 
-- sub-types that can have extra fields etc for special purposes (e.g.
-- a monitor can create a MONITOR gpio_transfer with extra fields).
type gpio_transfer_kind_t : [GENERIC];


-- =============================================================================
-- UVC Data Item
-- =============================================================================
struct gpio_transfer like any_sequence_item {
    
    -- *************************************************************************
    -- -------------------------------------------------------------------------
    -- Adjust the transfer attribute names as required, and add the
    -- necessary attributes.
    -- Note that if you change an attribute name, you must change the name in
    -- all of your UVC files.
    -- *************************************************************************
    
    kind : gpio_transfer_kind_t;
       keep soft kind == GENERIC;
    %data       : gpio_data_t;

}; 



'>
 
