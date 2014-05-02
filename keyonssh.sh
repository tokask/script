#!/bin/bash
SERVER=192.168.0.100
ssh-keygen
ssh-copy-id $USER@$SERVER
ssh $USER@$SERVER

