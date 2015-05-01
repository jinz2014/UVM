-----------------------------------------------------------------
File name     : spi_types.e
Created       : Tue Jul 27 13:52:04 2008
Description   : This file declares common types used throughout the UVC.
Notes         :
-----------------------------------------------------------------
//  Copyright 1999-2010 Cadence Design Systems, Inc.
//  All Rights Reserved Worldwide
//
//  Licensed under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in
//  compliance with the License.  You may obtain a copy of
//  the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in
//  writing, software distributed under the License is
//  distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//  CONDITIONS OF ANY KIND, either express or implied.  See
//  the License for the specific language governing
//  permissions and limitations under the License.
-------------------------------------------------------------------

<'

package spi;

type spi_agent_class_t    : [HANDLER]; // possible agent types
type spi_agent_name_t     : []; // agent real names
type spi_env_name_t       : []; // environment real names
type spi_owner_t          : [MONITOR, BFM];
extend message_tag        : [VR_SPI];
type spi_op_mode_t        : [PIN3, PIN4, PIN5];
type spi_driving_mode_t   : [SLAVE, MASTER];
type spi_clock_polarity_t : [POSEDGE, NEGEDGE];
type spi_clock_phase_t    : [BEFORE, ALIGNED];

'>
