#!/bin/bash
# Copyright 2022 The Magma Authors.

# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Here we make necessary changes for a magma debian-based production system
# that are needed to run the integration tests

# Use non-production control proxy configuration
mkdir -p /var/opt/magma/configs
ln -sf /home/vagrant/magma/lte/gateway/configs/control_proxy.yml /var/opt/magma/configs/control_proxy.yml

# Copy test certificates
mkdir -p /var/opt/magma/certs/
cp /home/vagrant/magma/.cache/test_certs/rootCA.* /var/opt/magma/certs/

# Override pipelined and sessiond production configuration
ln -sf /home/vagrant/magma/lte/gateway/configs/pipelined.yml /etc/magma/pipelined.yml
ln -sf /home/vagrant/magma/lte/gateway/configs/sessiond.yml /etc/magma/sessiond.yml

# Ensure changes in repository are used in services
ln -sf /home/vagrant/magma/lte/gateway/configs/templates/mme.conf.template /etc/magma/templates/mme.conf.template
ln -sf /home/vagrant/magma/lte/gateway/configs/gateway.mconfig /etc/magma/gateway.mconfig

# ssh test configuration
cp /home/vagrant/magma/lte/gateway/deploy/roles/dev_common/files/sshd_config /etc/ssh
service ssh reload

# Fake python environment so magma_test ssh calls on activate will not fail
mkdir -p /home/vagrant/build/python/bin
touch /home/vagrant/build/python/bin/activate

# Make magma_test ssh calls on python3 possible
ln -sf /usr/bin/python3 /home/vagrant/build/python/bin/python3

# Override production service configurations with test configurations
rm -f /etc/systemd/system/magma*
cp /home/vagrant/magma/orc8r/tools/ansible/roles/gateway_services/files/magma.service /etc/systemd/system/magma@.service
cp /home/vagrant/magma/lte/gateway/deploy/roles/magma/files/systemd/magma_connectiond.service /etc/systemd/system/magma@connectiond.service
cp /home/vagrant/magma/orc8r/tools/ansible/roles/gateway_services/files/magma_control_proxy.service /etc/systemd/system/magma@control_proxy.service
cp /home/vagrant/magma/lte/gateway/deploy/roles/magma/files/systemd/magma_ctraced.service /etc/systemd/system/magma@ctraced.service
cp /home/vagrant/magma/lte/gateway/deploy/roles/magma/files/systemd/magma_dnsd.service /etc/systemd/system/magma@dnsd.service
cp /home/vagrant/magma/lte/gateway/deploy/roles/magma/files/systemd/magma_envoy_controller.service /etc/systemd/system/magma@envoy_controller.service
cp /home/vagrant/magma/lte/gateway/deploy/roles/magma/files/systemd/magma_eventd.service /etc/systemd/system/magma@eventd.service
cp /home/vagrant/magma/lte/gateway/deploy/roles/magma/files/systemd/magma_liagentd.service /etc/systemd/system/magma@liagentd.service
cp /home/vagrant/magma/lte/gateway/deploy/roles/magma/files/systemd/magma_lighttpd.service /etc/systemd/system/magma@lighttpd.service
cp /home/vagrant/magma/lte/gateway/deploy/roles/magma/files/systemd/magma_magmad.service /etc/systemd/system/magma@magmad.service
cp /home/vagrant/magma/lte/gateway/deploy/roles/magma/files/systemd/magma_mme.service /etc/systemd/system/magma@mme.service
cp /home/vagrant/magma/lte/gateway/deploy/roles/magma/files/systemd/magma_mobilityd.service /etc/systemd/system/magma@mobilityd.service
cp /home/vagrant/magma/lte/gateway/deploy/roles/magma/files/systemd/magma_pipelined.service /etc/systemd/system/magma@pipelined.service
cp /home/vagrant/magma/lte/gateway/deploy/roles/magma/files/systemd/magma_redirectd.service /etc/systemd/system/magma@redirectd.service
cp /home/vagrant/magma/lte/gateway/deploy/roles/magma/files/systemd/magma_redis.service /etc/systemd/system/magma@redis.service
cp /home/vagrant/magma/lte/gateway/deploy/roles/magma/files/systemd/magma_sessiond.service /etc/systemd/system/magma@sessiond.service
cp /home/vagrant/magma/orc8r/tools/ansible/roles/fluent_bit/files/magma_td-agent-bit.service /etc/systemd/system/magma@td-agent-bit.service
cp /home/vagrant/magma/lte/gateway/deploy/roles/magma/files/systemd/magma_dp_envoy.service /etc/systemd/system/magma_dp@envoy.service
systemctl daemon-reload
