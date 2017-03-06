#!/usr/bin/env python

# Copyright 2015 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from locust import HttpLocust, TaskSet, task
import os, random

requestList = None

with open('/locust-tasks/requests.txt', 'rb') as f:
    requestList = list(f)

class MetricsTaskSet(TaskSet):
    requestList = None

    def on_start(self):
        pass

    @task(10000)
    def get_requests(self):
        r = random.choice(list(range(0, len(requestList))))
        self.client.get(requestList[r])


class MetricsLocust(HttpLocust):
    task_set = MetricsTaskSet
    min_wait = 10
    max_wait = 100