'use client';

import {
  Box,
  Typography,
  Card,
  CardContent,
  CardActions,
  Button,
  Chip,
  CircularProgress,
  Alert,
  Avatar,
} from '@mui/material';
import { ArrowBack, ThumbUp, Person } from '@mui/icons-material';
import Layout from '@/components/Layout/Layout';
import Link from 'next/link';
import { useParams } from 'next/navigation';
import { useQuery } from '@tanstack/react-query';
import { featuresAPI } from '@/lib/api';
import { useVoteFeature } from '@/hooks/useFeatures';
import { ApiError } from '@/types/api';

export default function FeatureDetailPage() {
  const params = useParams();
  const featureId = parseInt(params.id as string);
  const voteFeatureMutation = useVoteFeature();

  const { data: feature, isLoading, isError, error } = useQuery({
    queryKey: ['feature', featureId],
    queryFn: () => featuresAPI.getFeature(featureId),
    enabled: !!featureId,
  });

  const handleVote = () => {
    if (feature) {
      voteFeatureMutation.mutate(feature.id);
    }
  };

  if (isLoading) {
    return (
      <Layout>
        <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '50vh' }}>
          <CircularProgress size={60} />
        </Box>
      </Layout>
    );
  }

  if (isError) {
    return (
      <Layout>
        <Alert severity="error" sx={{ mb: 4 }}>
          {(error as ApiError)?.response?.data?.detail || 'Failed to load feature. Please try again.'}
        </Alert>
      </Layout>
    );
  }

  if (!feature) {
    return (
      <Layout>
        <Alert severity="error" sx={{ mb: 4 }}>
          Feature not found.
        </Alert>
      </Layout>
    );
  }

  return (
    <Layout>
      <Box sx={{ mb: 4 }}>
        <Button
          startIcon={<ArrowBack />}
          component={Link}
          href="/features"
          sx={{ mb: 3 }}
        >
          Back to Features
        </Button>
      </Box>

      <Card sx={{ mb: 4 }}>
        <CardContent>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', mb: 3 }}>
            <Typography variant="h1" component="h1" sx={{ flex: 1, mr: 2 }}>
              {feature.title}
            </Typography>
            <Chip
              icon={<ThumbUp />}
              label={feature.vote_count}
              color="primary"
              size="large"
              sx={{ fontSize: '1.1rem', px: 2, py: 1 }}
            />
          </Box>

          {feature.description && (
            <Box sx={{ mb: 4 }}>
              <Typography variant="h3" component="h2" gutterBottom>
                Description
              </Typography>
              <Typography variant="body1" sx={{ whiteSpace: 'pre-wrap', lineHeight: 1.6 }}>
                {feature.description}
              </Typography>
            </Box>
          )}

          <Box sx={{ display: 'flex', alignItems: 'center', gap: 2, mb: 3 }}>
            <Avatar sx={{ width: 40, height: 40, bgcolor: 'primary.main' }}>
              <Person />
            </Avatar>
            <Box>
              <Typography variant="body1" fontWeight="medium">
                {feature.author.name}
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Proposed on {new Date(feature.created_at).toLocaleDateString('en-US', {
                  year: 'numeric',
                  month: 'long',
                  day: 'numeric',
                  hour: '2-digit',
                  minute: '2-digit'
                })}
              </Typography>
            </Box>
          </Box>

          <Box sx={{ p: 2, bgcolor: 'grey.50', borderRadius: 1 }}>
            <Typography variant="body2" color="text.secondary">
              <strong>Feature ID:</strong> {feature.id}
            </Typography>
          </Box>
        </CardContent>

        <CardActions sx={{ p: 3, pt: 0 }}>
          <Button
            variant="contained"
            startIcon={<ThumbUp />}
            onClick={handleVote}
            disabled={voteFeatureMutation.isPending}
            size="large"
          >
            {voteFeatureMutation.isPending ? 'Voting...' : `Vote (${feature.vote_count})`}
          </Button>
          
          {voteFeatureMutation.isError && (
            <Alert severity="error" sx={{ ml: 2, flex: 1 }}>
              {(voteFeatureMutation.error as ApiError)?.response?.data?.detail || 
               'Failed to vote. Please try again.'}
            </Alert>
          )}
        </CardActions>
      </Card>

      <Box sx={{ textAlign: 'center' }}>
        <Typography variant="body2" color="text.secondary">
          Help prioritize this feature by voting. Your feedback helps shape our roadmap.
        </Typography>
      </Box>
    </Layout>
  );
}