# Lab 09: Knowledge check

**Answer each question below it, in your own words, in one to three sentences.** Replace the `...` below **Your answer:** with your text.

## 1. Credentials in the image?

Assume you want to share your image with others and make it publicly available on `ghcr.io`, so that anyone can pull it and run the analysis. A teammate suggests adding `COPY .aws /home/app/.aws` to the `Dockerfile`, so that nobody has to type `-v ~/.aws:/home/app/.aws:ro` any more. (This is a thought experiment: keep your own package private.)

**Your answer:** Give two reasons why this is a bad idea. Think of who could then read your credentials, and of what happens when your Learner Lab session ends.

Copying AWS credentials directly into the Docker image would be a security risk because anyone who downloads the image could potentially access them. Also, since the Learner Lab credentials expire when the session ends, they wouldn't work permanently anyway. Mounting them at runtime is safer because the credentials aren't stored in the image.

## 2. Where did the Atlas password come from?

In Step 4, you ran the analysis once with `-v ~/.aws:/home/app/.aws:ro` only, without the three `-e` options. The container still wrote to your Atlas cluster.

*Hint:* Read `get_atlas_settings()` in `src/book_analysis/analyze.py`.

**Your answer:** Explain, step by step, where the container found the Atlas settings in that run.

Since I didn't pass the MongoDB environment variables, the program used its fallback method to get the credentials. The container accessed my AWS credentials through the mounted `.aws` folder, which allowed boto3 to retrieve the `mongodb_credentials` parameter from AWS Systems Manager Parameter Store. It then used those settings to connect to MongoDB Atlas.

## 3. Same tag, different image

Run `docker images book-analysis`, and note the image ID of `book-analysis:0.1.0`. Then change the `description` in the `LABEL` of your `Dockerfile`, build again with the same command, `docker build -t book-analysis:0.1.0 .`, and run `docker images book-analysis` again.

**Your answer:** Paste the image ID from before and after the rebuild. Why is it a problem for someone who uses your image that `0.1.0` now names a different image, and what should you have done instead?

Before Rebuild: abc50640018a
After Rebuild: 99ce5640e996
Even though I used the same 0.1.0 tag, rebuilding the image changed its image ID. This could cause problems because someone using that tag might end up with a different version than they expected. Instead, I should have given the updated image a new version tag, like 0.1.1.
