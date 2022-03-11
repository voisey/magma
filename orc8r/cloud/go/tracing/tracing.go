// Copyright The OpenTelemetry Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package tracing

import (
        "log"

        "go.opentelemetry.io/otel"
        "go.opentelemetry.io/otel/propagation"
		"go.opentelemetry.io/otel/sdk/resource"
        sdktrace "go.opentelemetry.io/otel/sdk/trace"
        "go.opentelemetry.io/otel/exporters/jaeger"
		semconv "go.opentelemetry.io/otel/semconv/v1.7.0"
)

// Init configures an OpenTelemetry exporter and trace provider
func Init(name string) *sdktrace.TracerProvider {
		exporter, err := jaeger.New(jaeger.WithAgentEndpoint(jaeger.WithAgentHost("jaeger"), jaeger.WithAgentPort("6831")))
        if err != nil {
                log.Fatal(err)
        }
		res, err := resource.Merge(
			resource.Default(),
			resource.NewWithAttributes(
				semconv.SchemaURL,
				semconv.ServiceNameKey.String(name),
			),
		)
        tp := sdktrace.NewTracerProvider(
                sdktrace.WithSampler(sdktrace.AlwaysSample()),
                sdktrace.WithBatcher(exporter),
				sdktrace.WithResource(res),
        )
        otel.SetTracerProvider(tp)
        otel.SetTextMapPropagator(propagation.NewCompositeTextMapPropagator(propagation.TraceContext{}, propagation.Baggage{}))
        return tp
}